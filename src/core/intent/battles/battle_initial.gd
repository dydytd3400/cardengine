extends ProcessTaskExecutor
class_name BattleInitial


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("战斗开始，初始化双方玩家数据",{},"BattleProcess")
	battle_field.players[0].init_deck()
	battle_field.players[1].init_deck()
	completed(task, msg)
