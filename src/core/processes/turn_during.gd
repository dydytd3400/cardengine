extends ProcessTaskExecutor
class_name TurnDuring

var battle_manager:BattleManager

func _execute(task: ProcessTask, msg: Dictionary = {}):
	battle_manager = msg.manager
	battle_manager.first_index = randi_range(0,1)
	battle_manager.turn_count += 1
	lg.info("回合开始，当前玩家是 %s" % battle_manager.current_player.name)
	complated(task,{"manager" = battle_manager,})
