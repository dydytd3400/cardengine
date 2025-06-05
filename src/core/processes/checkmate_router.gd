class_name CheckmateRouter
extends ProcessTaskRouter

var continue_task:StringName

func _find_next(_current_task: ProcessTask, _complated: bool, _msg: Dictionary = {}) -> ProcessTask:
	lg.info("开始路由"+str(_complated))
	if _complated:
		return null
	else:
		return _current_task.parent.get_task(continue_task)
