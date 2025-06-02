## 流程任务顺序路由
##
## 当[ProcessTask]退出后，会通过[ProcessTaskRouter]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 该路由通常更适用于[ProcessTaskBatch]，为顺序执行。[br]
## 当前[ProcessTask]的父节点如果是[ProcessTaskBatch]，且为其最后一个子任务，则会直接退出而不是等待路由指令。[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouterSequential
extends ProcessTaskRouter

func _find_next(current_task: ProcessTask, complated: bool, msg: Dictionary = {}) -> ProcessTask:
	# 处理完成后 通过自身路由获取下个同级任务
	var next_task:ProcessTask
	if !current_task.parent:
		return current_task
	if current_task.parent is ProcessTaskBatch:# 目前只有流程任务组存在默认路由
		var process: ProcessTaskBatch = current_task.parent as ProcessTaskBatch
		var at: int = process.tasks.find(current_task)
		if at < 0:
			push_error("State not exist at %d" % at)
			return null
		if at >= process.tasks.size()-1:
			process.private_state_machine.stop()
			return null
		next_task = process.tasks[at+1]
	else:
		var parent :BaseStateMachine = current_task.parent as BaseStateMachine
		var state_keys               = parent.states.keys()
		var at: int                  = state_keys.find(current_task.state_id)
		if at < 0:
			push_error("State not exist at %d" % at)
			return null
		if at >= state_keys.size()-1:
			parent.stop()
			return null
		next_task = parent.states[state_keys[at+1]]
	return next_task
