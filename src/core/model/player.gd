extends Resource
class_name Player

## 玩家UUID
var player_id: StringName
## 玩家昵称
var player_name: String = ""
## 当前血量
var health: int = 0
## 初始血量
var health_max: int = 0
## 当前金币
var gold: int = 0
## 初始卡牌 该数据不可发生变化
var cards: Array[Card] = []
## 当前牌库
var deck: Array[Card] = []
## 当前手牌
var hand: Array[Card] = []
## 当前牌桌上的卡牌
var plays: Array[Card] = []
## 当前墓堆
var graveyard: Array[Card] = []
## 废弃的卡
var trashed: Array[Card] = []
## 是否先手玩家
var is_first: bool = false

## 利息增长
func interest_payout(_turn_count: int) -> int:
	var interest =  1 #+_turn_count + floori(gold / 5.0)
	gold += interest
	return interest


## 出牌 临时随机
func play_card():
	for i in range(hand.size() - 1, -1, -1):
		var card = hand[i]
		if card.cost <= gold:
			gold -= card.cost
			plays.append(card)
			lg.info("玩家: %s打出了一张牌%d费:%s,当前剩余%d枚金币" % [player_name, card.cost, card.card_name,gold])
			hand.remove_at(i)

# TODO 每个move都应该需要await 因为每次移动都可能变更后者的移动范围
# TODO 确立移动时序规则
## 行军，所有牌桌卡牌移动并攻击 [param _attack],是否移动后立即攻击，默认为true
# func march(_attack: bool = true) -> void:
# 	for card in plays:
# 		await card.move()
		# if _attack:
		# 	await card.attack()

# func draw_card(count:int = 1)->Array[Card]:
# 	var draws = []
# 	if deck.is_empty():
# 		return draws
# 	var real_count = min(count,deck.size())
# 	for i in range(real_count):
# 		draws.append(deck.pop_at(randi_range(0,real_count-1-i)))
# 	return draws
