extends ProcessTaskExecutor
class_name TurnDuring


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	battle_field.turn_count += 1
	lg.info("回合开始，当前玩家是 %s" % battle_field.current_player.name)
	completed(task,msg)
