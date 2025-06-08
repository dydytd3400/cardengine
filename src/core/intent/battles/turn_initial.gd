extends ProcessTaskExecutor
class_name TurnInital


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("回合开始，当前玩家是 %s" % battle_field.current_player.player_name,{},"BattleProcess")
	completed(task,msg)
