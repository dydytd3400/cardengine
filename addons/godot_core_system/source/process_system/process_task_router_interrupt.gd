## 中断流程任务顺序路由
##
## 该路由通常更适用于[ProcessTaskBatch]中concurrent为true时，当任务进入到该路由后直接退出。[br]
## @experimental: 请慎用该路由。
class_name ProcessTaskRouterInterrupt
extends ProcessTaskRouter

func _find_next(current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	current_task.exit()
	return null
