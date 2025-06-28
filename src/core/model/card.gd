@tool
class_name Card extends Node
#var TAG = "BattleProcess"
var TAG = "Card"
var view: CardNode
var view_res: PackedScene = load("res://src/core/view/card/card_node.tscn")
@export
var data: CardData:
	set(value):
		data = value
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
		view.cost = value
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
		view.health = value
		if value<=0 && card_type != DataEnums.CardType.SPELL:
			to_death()
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
		view.attack = value
## 初始攻击力
var attack_max: int:
	get(): return data.attack
	set(val):
		view.attack_max = val
		attack = val
## 可攻击区域 以自身为中心的相对坐标
var attack_area: Array[Vector2i] = []
## 攻击方式
var attack_type: Ability

#========================移动相关========================
## 移动距离 单次移动可移动的最大格数
var mobility: int = 0:
	set(value):
		mobility = value
		view.mobility = value
## 初始移动距离
var mobility_max: int = 0:
	get(): return data.mobility
	set(val):
		view.mobility_max = val
		mobility = val
## 可移动区域 以自身为中心的相对坐标
var move_area: Array[Vector2i] = []
## 移动方式
var move_type: Ability
## 卡牌类型
var card_type:DataEnums.CardType:
	get():return data.card_type
## 独占 仅卡牌类型为地形时，该值才可变
var exclusive:bool:
	get():
		if !alive:
			return false
		if card_type == DataEnums.CardType.TERRAIN:
			return exclusive
		return true
	set(val):
		if card_type == DataEnums.CardType.TERRAIN:
			exclusive = val
## 当前卡牌是否可被选为目标 只要卡牌类型不是技能时，该值都可变 且该值的初始值由计算而来
var target_able:bool:
	get():
		if !alive:
			return false
		if card_type != DataEnums.CardType.SPELL:
			return target_able
		return true
	set(val):
		if card_type != DataEnums.CardType.SPELL:
			target_able = val


## 能力集
var abilitys: Array[Ability] = []
## 卡牌描述
var text: String:
	get: return data.text
	set(val):
		view.text = val

var activated = false:
	get():return alive && activated
	set(val):
		activated = val
		view.activated = val

var alive = false:
	get(): return  CardState.ALIVE_STATE.find(states.current_state.state_id) >= 0

var resist_able = true:
	get():return alive && card_type == DataEnums.CardType.ORGANISM && resist_able
	set(val):
		resist_able = val

## 卡牌持有者 仅卡牌处于战场时有值 当[member holder]为空时，则代表该卡牌为中立单位
#TODO 后期是否需要拓展出中立单位对象 否则需要多出一个字段来标记是否处于战场
var holder: Player
## 卡牌创建者 对局中创建该卡牌的玩家或创建了该卡牌的卡牌持有者
var creator: Player

## 卡牌所在的卡槽
var slot: Slot

var states:CardState

func initialize(_data: CardData, _creator: Player, _holder: Player = _creator):
	view = view_res.instantiate()
	data = _data
	holder = _holder
	creator = _creator
	states = CardState.new(self)

func to_table():
	lg.info("卡牌: %s 进入牌桌" % card_name, {}, TAG)
	states.switch(CardState.TABLE,{ "card" = self})
	await CoreSystem.get_tree().create_timer(0.5)

func to_activate():
	lg.info("卡牌: %s 开始激活" % card_name, {}, TAG)
	if activated:
		return
	if states.current_state && states.current_state.state_id == CardState.TABLE:
		activated = true
		states.switch(CardState.ACTIVATE,{ "card" = self})

func to_move():
	lg.info("卡牌: %s 开始移动" % card_name, {}, TAG)
	if !activated:
		return
	if move_type && move_area && !move_area.is_empty():
		states.switch(CardState.MOVE,{ "card" = self})
		await move_type.ability_finish

func to_attack():
	lg.info("卡牌: %s 开始攻击" % card_name, {}, TAG)
	if !activated:
		return
	if attack_type && attack_area && !attack_area.is_empty():
		states.switch(CardState.ATTACK,{ "card" = self})
		await move_type.ability_finish

func to_death():
	lg.info("卡牌: %s 被干死了！" % card_name, {}, TAG,lg.LogLevel.WARNING)
	states.switch(CardState.USED,{ "card" = self})

func is_enemy(target):
	if !target:
		lg.warning("Enemy check target is empty!")
		return false
	if target is Player:
		return holder != target
	if target is Card:
		return holder != target.holder
	if target is Slot:
		return holder != target.holder
	return false

func bind_data():
	card_name = data.card_name
	cost_max = data.cost
	text = data.text
	abilitys = data.abilitys
	if card_type == DataEnums.CardType.ORGANISM:
		health_max = data.health
		attack_max = data.attack
		attack_type = data.attack_type
		attack_area = data.attack_area.area
		mobility_max = data.mobility
		move_type = data.move_type
		move_area = data.move_area.area
		target_able = true
	if card_type == DataEnums.CardType.TERRAIN:
		health_max = data.health
		exclusive = data.exclusive
		target_able = true

	if attack_type:
		attack_type.initialize(self)
	if move_type:
		move_type.initialize(self)
	if abilitys:
		for ability in abilitys:
			ability.initialize(self)
	if data.frame_style:
		view.frame_style = data.frame_style
