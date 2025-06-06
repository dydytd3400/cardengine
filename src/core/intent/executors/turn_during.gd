extends ProcessTaskExecutor
class_name TurnDuring


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("回合开始，当前玩家是 %s" % battle_field.current_player.player_name)
	completed(task,msg)
