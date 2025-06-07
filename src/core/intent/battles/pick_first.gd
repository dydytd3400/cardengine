extends ProcessTaskExecutor
class_name PickFirst


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	battle_field.pick_first()
	completed(task, msg)
