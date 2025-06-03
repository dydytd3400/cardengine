extends ProcessTaskExecutor
class_name BattleInitial

var battle_manager:BattleManager

func _execute(task: ProcessTask, msg: Dictionary = {}):
	battle_manager = msg.manager
	lg.info("战斗开始，初始化双方玩家数据")
	battle_manager.players.append(Player.new())
	battle_manager.players.append(Player.new())
	battle_manager.players[0].name = "张三"
	battle_manager.players[0].id = 0
	battle_manager.players[1].name = "李四"
	battle_manager.players[1].id = 1
	complated(task, {
		"manager" = battle_manager,
		"player" = battle_manager.current_player,
		"count" = 3,
	})
