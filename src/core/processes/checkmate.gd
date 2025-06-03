extends ProcessTaskExecutor
class_name Checkmate

var battle_manager:BattleManager

func _execute(task: ProcessTask, msg: Dictionary = {}):
	battle_manager = msg.manager
	battle_manager.first_index = randi_range(0,1)
	lg.info("第%d个回合结束" % battle_manager.turn_count)
	if battle_manager.turn_count < 10:
		cancel(task, {
			"manager" = battle_manager,
			 "player" =  battle_manager.next()
			})
	else:
		lg.info("全部流程结束啦")
		complated(task,{"manager" = battle_manager,})
