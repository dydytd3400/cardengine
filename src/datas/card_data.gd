extends Resource
class_name CardData

## 卡牌名称
@export
var card_name: String = ""
## 卡牌UUID
@export
var card_id: StringName

## 当前费用
@export
var cost: int = 0

## 当前血量
@export
var health: int = 0
## 初始血量
@export
var health_max: int = 0

#========================攻击相关========================
## 当前攻击力[br]
## 移动和攻击为两个特殊能力，属于多数卡牌的基础能力，一旦有，同类型就只可能有一个，所以从能力集[member abilitys]中单列出来
@export
var attack: int = 0
## 可攻击区域 以自身为中心的相对坐标
@export
var attack_area: Array[Vector2] = []
## 攻击方式
@export
var attack_type: AbilityAttack

#========================移动相关========================
## 移动距离 单次移动可移动的最大格数
@export
var mobility: int = 0
## 可移动区域 以自身为中心的相对坐标
@export
var move_area: Array[Vector2] = []
## 移动方式
@export
var move_type: AbilityMove

## 能力集
@export
var abilitys: Array[Ability] = []
## 卡牌描述
@export
var text: String
