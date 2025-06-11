extends ProcessTaskExecutor
class_name CardAttack

func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	card.to_attack()
	completed(task,msg)
