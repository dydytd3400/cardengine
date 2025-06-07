## 流程任务组执行模块
##
## 负责管理所属[ProcessTaskBatch]的专属执行模块，当[ProcessTaskExecutorBatch]开始执行时，会将首个被添加到当前[ProcessTaskBatch]的[ProcessTask]做为[member ProcessTaskBatch.private_state_machine]的启动状态并进入。[br]
## 当最后一个被添加到[ProcessTaskBatch]的[ProcessTask]退出后，则[ProcessTaskBatch]的执行模块也随之结束[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutorBatch
extends ProcessTaskExecutor

var _task_count

func _execute(task: ProcessTask, msg: Dictionary = {}) -> void:
	if !(task is ProcessTaskBatch):
		push_error("Invalid task type: Must be ProcessTaskBatch!")
		return
	var task_batch: ProcessTaskBatch =  task as ProcessTaskBatch
	_task_count = task_batch.tasks.size()

	if task_batch.concurrent:
		for item_task in task_batch.tasks:
			item_task.state_exited.connect(_finish_one.bind(task,msg))
			item_task.enter(msg)
	else:
		var last_task := task_batch.tasks[task_batch.tasks.size()-1]
		last_task.state_exited.connect(_finish.bind(task,msg))
		var first_task := task_batch.tasks[0]
		if task_batch.private_state_machine.current_state==null: # 如果子状态机没启动 则启动第一个子流程任务  否则切换至第一个子流程任务
			task_batch.private_state_machine.start(first_task.state_id, msg)
		else:
			task_batch.private_state_machine.switch(first_task.state_id, msg)


func _finish(task: ProcessTask, msg: Dictionary = {}) -> void:
	completed(task, msg)

func _finish_one(task: ProcessTask, msg: Dictionary = {}) -> void:
	task.state_exited.disconnect(_finish_one)
	_task_count-=1
	if _task_count<=0:
		completed(task, msg)
