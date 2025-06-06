extends ProcessTaskExecutor
class_name InitalHand

var count = 0
func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	var player = battle_field.current_player
	var cards:Array[Card] = player.cards
	var card_name =""
	for i in range(0,count):
		var card = Card.new()
		card_name+=card.card_name+", "
		cards.append(card)
	var is_first = player.id == battle_field.first_index
	lg.info("%s手玩家抽%d张牌:%s" % ["先" if is_first else "后",count,card_name])
	var time = randf_range(1,8)
	lg.info(str(time)+"秒后接受")
	CoreSystem.time_manager.create_timer(UUID.generate(),time,false,func ():completed(task,msg))
