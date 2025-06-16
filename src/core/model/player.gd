extends Node
class_name Player

@export
var view: PlayerNode
var data: PlayerData:
	set(value):
		data = value
		bind_data()
@export
var table: Table

## 玩家UUID
var player_id: StringName:
	get(): return data.player_id

## 玩家昵称
var player_name: String:
	get(): return data.player_name
	set(value): view.player_name = value
## 当前血量
var health: int = 0:
	get(): return health
	set(value):
		health = value
		view.health = value
## 初始血量
var health_max: int = 0:
	get(): return data.health
	set(value):
		health = value
		view.health_max = value
## 当前金币
var gold: int = 0:
	get(): return gold
	set(value):
		gold = value
		view.gold = value
## 初始卡牌 该数据不可发生变化
var cards: Array[CardData]:
	get(): return data.cards
	set(value):
		view.cards = value
var slots:Array[Slot]:
	get(): return table.slot_of_player[player_id]

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
@export
var card_res: Resource

## 利息增长
func interest_payout(_turn_count: int) -> int:
	var interest = 1 # +_turn_count + floori(gold / 5.0)
	gold += interest
	lg.info("回合开始，玩家: %s 增长了%d枚金币，现在共持有%d枚" % [player_name, interest, gold], {}, "BattleProcess")
	return interest


## 出牌 临时随机
func play_card():
	for i in range(hand.size() - 1, -1, -1):
		var card = hand[i]
		if card.cost <= gold: # 费用足够
			for slot in slots:
				if slot.add_able: # 有空余卡槽
					gold -= card.cost # 扣除费用
					plays.append(card)# 添加进牌桌数组
					table.hand_to_table(card,slot.index) # 添加进牌桌
					lg.info("玩家: %s打出了一张牌%d费:%s,当前剩余%d枚金币" % [player_name, card.cost, card.card_name, gold], {}, "BattleProcess")
					hand.remove_at(i)# 从手牌移除
					break


## 初始化牌库
func init_deck():
	for card in cards:
		var card_data: CardData = card.duplicate(true)
		var new_card: Card = card_res.new()
		new_card.initialize(card_data, self)
		deck.append(new_card)

func bind_data():
	health_max = data.health
	health = data.health
	gold = data.gold
	cards = data.cards
	player_name = data.player_name
