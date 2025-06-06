extends Object
class_name Player

## 玩家UUID
var player_id:StringName
## 玩家昵称
var player_name: String = ""
## 当前血量
var health: int = 0
## 初始血量
var health_max: int = 0
## 当前金币
var gold: int = 0
## 初始卡牌 该数据不可发生变化
var cards:Array[Card] = []
## 当前牌库
var deck:Array[Card] = []
## 当前手牌
var hand:Array[Card] = []
## 当前牌桌上的卡牌
var plays:Array[Card] = []
## 当前墓堆
var graveyard:Array[Card] = []
## 废弃的卡
var trashed:Array[Card] = []
## 是否先手玩家
var is_first:bool = false

func draw_card(count:int = 1)->Array[Card]:
	var draws = []
	if deck.is_empty():
		return draws
	var real_count = min(count,deck.size())
	for i in range(real_count):
		draws.append(deck.pop_at(randi_range(0,real_count-1-i)))
	return draws
