extends ProcessTaskExecutor
class_name PickFirst


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	battle_field.pick_first()
	lg.info("当前先手玩家是 %s" % battle_field.current_player.player_name)
	completed(task, msg)
