extends ProcessTaskExecutor
class_name TurnDuring


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_manager = msg.manager
	battle_manager.turn_count += 1
	lg.info("回合开始，当前玩家是 %s" % battle_manager.current_player.name)
	complated(task,msg)
