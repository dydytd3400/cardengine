extends ProcessTaskExecutor
class_name CardActivate

func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	card.to_activate()
	completed(task,msg)
