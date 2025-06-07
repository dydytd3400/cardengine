## 流程任务组
##
## 基于[ProcessTask]的拓展类，用于管理多个[ProcessTask]子任务。[br]
## [br]
## [ProcessTaskBatch]的执行模块[ProcessTaskExecutor]不再可通过[ProcessTemplate]配置，而是固定由[ProcessTaskExecutorBatch]或[ProcessTaskExecutorConcurrent]代理。[br]
## [br]
## 和[ProcessTask]一样，[ProcessTaskBatch]仍然可以被做为一个普通[BaseState]被[BaseStateMachine]所管理[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskBatch
extends ProcessTask

## 子状态机，用于管理被添加到当前[ProcessTaskBatch]的子任务集
var private_state_machine: BaseStateMachine = BaseStateMachine.new()
## 子任务集数组容器，该数组的下标即为被添加进当前流程任务组的时序
var tasks: Array[ProcessTask]               = []
## 子任务集字典容器，方便通过state_id获取任务
var tasks_dict: Dictionary[StringName, ProcessTask] = {}
## 是否为并发任务
## 该值为true时，该[ProcessTaskBatch]的当前层级的子[ProcessTask]将会并发执行，在执行完成后，[ProcessTask]会各自退出且不再进行路由。当所有子[ProcessTask]都退出后，该[ProcessTaskBatch]也随之完成。
var concurrent:bool = false

## 构造方法，和[ProcessTask]一样只能直接创建，不同之处在于只可以传入一个[ProcessTaskRouter]。
func _init(_router: ProcessTaskRouter,_concurrent:bool=false):
	super._init(ProcessTaskExecutorBatch.new(),_router)
	concurrent=_concurrent
	private_state_machine.is_debug = is_debug

## 添加子任务 [param task_id]：子任务在当前流程组的唯一ID。[param new_task]：需要添加的子任务
func add_task(task_id: StringName, new_task: ProcessTask) -> void:
	if is_active:
		push_error("ProcessTaskBatch %s is active!" % state_id)
		return
	tasks.append(new_task)
	new_task.parent = self
	if !concurrent:
		private_state_machine.add_state(task_id, new_task)
	else:
		tasks_dict[task_id] = new_task
		new_task.is_debug = is_debug
		new_task.state_id = state_id
		new_task.parent = self

## 通过task_id获取子任务
func get_task(task_id:StringName) -> ProcessTask:
	if !concurrent:
		return private_state_machine.states[task_id]
	else:
		return tasks_dict[task_id]

## 通过task_index获取子任务
func get_task_at(task_index:int) -> ProcessTask:
	return tasks[task_index]


func _exit() -> void:
	# 通常如果子状态机正常结束，
	# 如果是被外部手动调用，需要主动停止状态机
	if !concurrent:
		#if private_state_machine.is_active:
			private_state_machine.stop()
	else:
		for task in tasks:
			if task.is_active:
				task.exit()

func _set_state_id(value:StringName) -> void:
	private_state_machine.state_id = value

func _get_state_id() -> StringName:
	return private_state_machine.state_id
