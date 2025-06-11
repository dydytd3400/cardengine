extends Resource
class_name PlayerData
## 玩家UUID
var player_id: StringName
## 玩家昵称
var player_name: String = ""
## 当前血量
var health: int = 0
## 当前金币
var gold: int = 0
## 初始卡牌 该数据不可发生变化
var cards: Array[CardData] = []
