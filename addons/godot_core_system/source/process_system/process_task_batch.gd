## 流程任务组
##
## 基于[ProcessTask]的拓展类，用于管理多个[ProcessTask]子任务。[br]
## [br]
## [ProcessTaskBatch]的执行模块无法通过[ProcessTemplate]配置，而是固定由[ProcessTaskExecutor]代理。[br]
## [br]
## 和[ProcessTask]一样，[ProcessTaskBatch]仍然可以被做为一个普通[BaseState]被[BaseStateMachine]所管理[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskBatch
extends ProcessTask

# 信号
## 状态改变
signal state_changed(from_state: ProcessTask, to_state: ProcessTask, msg: Dictionary)
## 子任务集数组容器，该数组的下标即为被添加进当前流程任务组的时序
var tasks: Array[ProcessTask] = []
## 子任务集字典容器，方便通过state_id获取任务
var tasks_dict: Dictionary[StringName, ProcessTask] = {}
## 是否为并发任务
## 该值为true时，该[ProcessTaskBatch]的当前层级的子[ProcessTask]将会并发执行，在执行完成后，[ProcessTask]会各自退出且不再进行路由。当所有子[ProcessTask]都退出后，该[ProcessTaskBatch]也随之完成。
var concurrent: bool = false
## 当前状态
var current_task: ProcessTask
## 上一个状态
var previous_task: StringName = &""
var _task_count


## 构造方法，和[ProcessTask]一样只能直接创建，不同之处在于只可以传入一个[ProcessTaskRouter]。
func _init(_router: ProcessTaskRouter, _concurrent: bool = false):
	super._init(ProcessTaskExecutor.new(), _router)
	concurrent = _concurrent
	state_exited.connect(on_exited)


## 进入当前任务状态
## 调度[member executor]执行具体任务，并通过[param msg]附带参数
func on_entered(msg: Dictionary):
	super.on_entered(msg)
	_task_count = tasks.size()
	if concurrent:
		for item_task in tasks:
			item_task.state_exited.connect(_finish_one.bind(msg))
			item_task.enter(msg)
	else:
		switch(tasks[0].state_id, msg)


func on_exited():
	if !concurrent:
		if current_task:
			current_task.exit()
	else:
		for task in tasks:
			if task.is_active:
				task.exit()


## 添加子任务 [param task_id]：子任务在当前流程组的唯一ID。[param new_task]：需要添加的子任务
func add_task(task_id: StringName, new_task: ProcessTask) -> void:
	if is_active:
		lg.fatal("ProcessTaskBatch %s is active!" % state_id)
		return
	tasks.append(new_task)
	new_task.parent = self
	tasks_dict[task_id] = new_task
	new_task.state_id = task_id


## 切换状态
func switch(state_id: StringName, msg: Dictionary = {}) -> void:
	if concurrent:
		lg.fatal("Attempting to transition to non-existent state: %s" % state_id)
		return

	if not tasks_dict.has(state_id):
		lg.fatal("Attempting to transition to non-existent state: %s" % state_id)
		return

	var from_task = current_task
	if current_task:
		previous_task = get_current_task_name()
		current_task.exit()

	current_task = tasks_dict[state_id]
	if not current_task:
		lg.fatal("Attempting to transition to non-existent state: %s" % state_id)
		return

	current_task.enter(msg)
	state_changed.emit(from_task, current_task, msg)


func _finish_one(msg: Dictionary = {}) -> void:
	_task_count -= 1
	if _task_count <= 0:
		executor.completed(self, msg)


## 获取当前状态名称
func get_current_task_name() -> StringName:
	return current_task.state_id if current_task else &""


## 通过task_id获取子任务
func get_task(task_id: StringName) -> ProcessTask:
	return tasks_dict[task_id]


## 通过task_index获取子任务
func get_task_at(task_index: int) -> ProcessTask:
	return tasks[task_index]
