extends ProcessTaskExecutor
class_name PickFirst


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	battle_field.first_index = randi_range(0,1)
	lg.info("当前先手玩家是 %s" % battle_field.current_player.name)
	completed(task, msg)
