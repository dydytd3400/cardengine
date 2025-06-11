extends ProcessTaskExecutor
class_name CardMove


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	card.to_move()
	completed(task,msg)
