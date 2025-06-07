extends ProcessTaskExecutor
class_name InterestPayout


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	var player :Player = battle_field.current_player
	lg.info("回合开始，玩家: %s 增长了%d枚金币，现在共持有%d枚" % [player.player_name,player.interest_payout(floor(battle_field.turn_count/2.0)),player.gold])
	completed(task,msg)
