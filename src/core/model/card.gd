extends Resource
class_name Card

## 卡牌名称
@export
var card_name: String = ""
## 卡牌UUID
@export
var card_id: StringName

## 当前费用
@export
var cost: int = 0
## 初始费用
@export
var cost_max = 0

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
## 初始攻击力
@export
var attack_max: int = 0
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
## 初始移动距离
@export
var mobility_max: int = 0
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

## 卡牌持有者 仅卡牌处于战场时有值 当[member owner]为空时，则代表该卡牌为中立单位
#TODO 后期是否需要拓展出中立单位对象 否则需要多出一个字段来标记是否处于战场
var owner: Player
## 卡牌创建者 对局中创建该卡牌的玩家或创建了该卡牌的卡牌持有者
var creator: Player

## 卡牌所在的卡槽
var slot: Slot

func to_move():
	if move_type && mobility>0 && !move_area.is_empty():
		move_type.execute()

func to_attack():
	if attack_type && attack>0 && !attack_area.is_empty():
		move_type.execute()
