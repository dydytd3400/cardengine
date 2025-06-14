extends Node
class_name Card
#var TAG = "BattleProcess"
var TAG = "Card"
var view: CardNode
var view_res:PackedScene = load("res://src/core/view/card/card_node.tscn")
var data: CardData:
	set (value):
		data=value
		bind_data()

#var process:ProcessTask = ProcessTemplate.new().generate(ProcessConfig.card_process_config)

## 卡牌UUID
var card_id: StringName:
	get(): return data.card_id
## 卡牌名称
var card_name: String:
	get(): return data.card_name
	set(val):
		view.card_name = val

## 当前费用
var cost: int = 0:
	set(value):
		cost = value
		view.cost=value
## 初始费用
var cost_max: int:
	get(): return data.cost
	set(val):
		view.cost_max = val
		cost = val

## 当前血量
var health: int = 0:
	set(value):
		health = value
		view.health=value
## 初始血量
var health_max: int:
	get(): return data.health
	set(val):
		view.health_max = val
		health = val

#========================攻击相关========================
## 当前攻击力[br]
## 移动和攻击为两个特殊能力，属于多数卡牌的基础能力，一旦有，同类型就只可能有一个，所以从能力集[member abilitys]中单列出来
var attack: int = 0:
	set(value):
		attack = value
		view.attack=value
## 初始攻击力
var attack_max: int:
	get(): return data.attack
	set(val):
		view.attack_max = val
		attack = val
## 可攻击区域 以自身为中心的相对坐标
var attack_area: Array[Vector2] = []
## 攻击方式
var attack_type: AbilityAttack

#========================移动相关========================
## 移动距离 单次移动可移动的最大格数
var mobility: int = 0:
	set(value):
		mobility = value
		view.mobility=value
## 初始移动距离
var mobility_max: int = 0:
	get(): return data.mobility
	set(val):
		view.mobility_max = val
		mobility = val
## 可移动区域 以自身为中心的相对坐标
var move_area: Array[Vector2] = []
## 移动方式
var move_type: AbilityMove

## 能力集
var abilitys: Array[Ability] = []
## 卡牌描述
var text: String:
	get:return data.text
	set(val):
		view.text=val

var activated = false:
	set(val):
		activated = val
		view.activated=val

## 卡牌持有者 仅卡牌处于战场时有值 当[member holder]为空时，则代表该卡牌为中立单位
#TODO 后期是否需要拓展出中立单位对象 否则需要多出一个字段来标记是否处于战场
var holder: Player
## 卡牌创建者 对局中创建该卡牌的玩家或创建了该卡牌的卡牌持有者
var creator: Player

## 卡牌所在的卡槽
var slot: Slot

func initialize(_data:CardData,_creator: Player,_holder: Player = _creator):
	view = view_res.instantiate()
	data = _data
	holder = _holder
	creator = _creator
	#process.enter({"card":self})

func to_move():
	lg.info("卡牌: %s 开始移动" % card_name,{},TAG)
	if !activated:
		return
	if move_type && mobility > 0 && !move_area.is_empty():
		move_type.execute()

func to_attack():
	lg.info("卡牌: %s 开始攻击" % card_name,{},TAG)
	if !activated:
		return
	if attack_type && attack > 0 && !attack_area.is_empty():
		move_type.execute()

func to_activate():
	lg.info("卡牌: %s 开始激活" % card_name,{},TAG)
	if activated:
		return
	activated = true

func bind_data():
	health_max = data.health
	cost_max = data.cost
	attack_max = data.attack
	attack_area = data.attack_area
	attack_type = data.attack_type
	mobility_max = data.mobility
	move_area = data.move_area
	move_type = data.move_type
	card_name = data.card_name
	text = data.text
