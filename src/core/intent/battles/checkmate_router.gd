class_name CheckmateRouter
extends ProcessTaskRouter

var continue_task:StringName

func _find_next(_current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	if _completed:
		return null
	else:
		return _current_task.parent.get_task(continue_task)
