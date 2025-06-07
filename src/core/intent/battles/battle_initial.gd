extends ProcessTaskExecutor
class_name BattleInitial


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("战斗开始，初始化双方玩家数据")
	init_player_deck(battle_field.players[0])
	init_player_deck(battle_field.players[1])
	completed(task, msg)

func init_player_deck(player:Player):
	for card in player.cards:
		var new_card:Card= card.duplicate(true)
		new_card.owner = player
		new_card.creator = player
		player.deck.append(new_card)
