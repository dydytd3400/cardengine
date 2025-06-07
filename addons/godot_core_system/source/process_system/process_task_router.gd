## 流程任务路由
##
## 当[ProcessTask]退出后，会通过[method _find_next]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 只允许在同级流程任务之间进行路由[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouter
extends RefCounted

## 当前任务结束时，会通过该方法调用[method _find_next]找到下一个同级流程任务并在当前方法路由[br]
## 如果[method _find_next]返回空，则流程任务会挂起，直到[method next]被再次执行或退出了当前流程任务。如果返回的流程任务没有父节点，则会直接退出当前流程任务。
func next(current_task: ProcessTask, completed: bool, msg: Dictionary = {}) -> void:
	var next_task := _find_next(current_task,completed,msg)
	if next_task:
		var parent = next_task.parent
		if !parent:
			lg.warning("Has no parent, about to exit : %s" % next_task.state_id)
			next_task.exit()
		else :
			if parent is ProcessTaskBatch && parent.concurrent:
				next_task.exit()
			else:
				current_task.switch_to(next_task.state_id,msg)


## 返回下一个同级流程任务
func _find_next(_current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	return null
