extends ProcessTaskExecutor
class_name PickFirst

var battle_manager:BattleManager

func _execute(task: ProcessTask, msg: Dictionary = {}):
	battle_manager = msg.manager
	battle_manager.first_index = randi_range(0,1)
	lg.info("当前先手玩家是 %s" % msg.player.name)

	complated(task, {
						"manager" = battle_manager,
						"player" = battle_manager.current_player,
						"count" = 3,
					})
