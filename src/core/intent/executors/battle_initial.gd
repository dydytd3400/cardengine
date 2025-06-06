extends ProcessTaskExecutor
class_name BattleInitial


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("战斗开始，初始化双方玩家数据")
	battle_field.players.append(Player.new())
	battle_field.players.append(Player.new())
	battle_field.players[0].name = "张三"
	battle_field.players[0].id = 0
	battle_field.players[1].name = "李四"
	battle_field.players[1].id = 1
	completed(task, msg)
