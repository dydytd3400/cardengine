class_name CheckmateRouter
extends ProcessTaskRouter

func _find_next(_current_task: ProcessTask, _complated: bool, _msg: Dictionary = {}) -> ProcessTask:
	lg.info("开始路由"+str(_complated))
	if _complated:
		return null
	else:
		var process: ProcessTaskBatch = _current_task.parent as ProcessTaskBatch
		return process.private_state_machine.states["turn_during"]
