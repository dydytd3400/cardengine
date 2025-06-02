## 流程任务路由
##
## 当[ProcessTask]退出后，会通过[ProcessTaskRouter]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 只允许在同级流程任务之间进行路由[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouter
extends RefCounted

## 当前任务已完成，路由至下个任务
## 如果没有找到下个任务，则流程会挂起，直到[method ProcessTaskRouter.next]被再次执行并通过[method ProcessTaskRouter._find_next]方法重新找到下一个流程任务或流程退出
## 如果下个任务没有父节点，则会直接退出当前流程任务
func next(current_task: ProcessTask, complated: bool, msg: Dictionary = {}) -> void:
	var next_task := _find_next(current_task,complated,msg)
	if next_task:
		var parent = next_task.parent
		if !parent:
			next_task._debug("Has no parent, about to exit")
			next_task.exit()
		else :
			current_task.switch_to(next_task.state_id,msg)

## 当前任务已完成，返回一个同级流程任务
## 如果返回空，则流程会暂停，直到[method ProcessTaskRouter.next]被再次执行并通过该方法找到另一个流程任务或流程退出
## 如果下个任务没有父节点，则会直接退出当前流程任务
func _find_next(current_task: ProcessTask, complated: bool, msg: Dictionary = {}) -> ProcessTask:
	return null
