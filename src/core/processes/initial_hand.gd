extends ProcessTaskExecutor
class_name InitalHand

var battle_manager:BattleManager

func _execute(task: ProcessTask, msg: Dictionary = {}):
	battle_manager = msg.manager
	var cards:Array[Card] = msg.player.cards
	var card_name =""
	for i in range(0,msg.count):
		var card = Card.new()
		card_name+=card.card_name+", "
		cards.append(card)
	var is_first = msg.player.id == battle_manager.first_index
	lg.info("%s手玩家抽%d张牌:%s" % ["先" if is_first else "后",msg.count,card_name])
	var next_msg:Dictionary
	if is_first:
		var second_player = battle_manager.players[0] if battle_manager.players[0] != msg.player else battle_manager.players[1]
		next_msg =  {
						"manager" = battle_manager,
						"player" = second_player,
						"count" = 4,
					}
	else:
		# 说明当前是后手玩家初始化手牌，则表示下一轮是进入回合状态
		next_msg = {
			"manager" = battle_manager,
			"player" =  msg.player,
		}
	complated(task,next_msg)
