## 卡牌资源配置

@tool
class_name CardData
extends Resource

## 卡牌名称
@export
var card_name: String = ""
## 卡牌UUID
@export_storage
var card_id: StringName

## 当前费用
@export
var cost: int = 0

## 卡牌类型
@export
var card_type :DataEnums.CardType = DataEnums.CardType.CHARACTER:
	set(value):
		card_type = value
		if  Engine.is_editor_hint():
			notify_property_list_changed()

## 初始血量
@export
var health: int = 0
## 独占
@export
var exclusive:bool = true

#========================攻击相关========================
## 当前攻击力[br]
## 移动和攻击为两个特殊能力，属于多数卡牌的基础能力，一旦有，同类型就只可能有一个，所以从能力集[member abilitys]中单列出来
@export_group("Attacks")
@export
var attack: int = 0
## 可攻击区域 以自身为中心的相对坐标
@export
var attack_area: RangeArea
## 攻击方式
@export
var attack_type: Ability

#========================移动相关========================
## 移动距离 单次移动可移动的最大格数
@export_group("Moves")
@export
var mobility: int = 0
## 可移动区域 以自身为中心的相对坐标
@export
var move_area: RangeArea
## 移动方式
@export
var move_type: Ability

## 能力集
@export_group("","")
@export
var abilitys: Array[Ability] = []
## 卡牌描述
@export
var text: String

var _property_usages := {}
func _validate_property(property: Dictionary) -> void:
	if  Engine.is_editor_hint():
		var attacks = ["attack","attack_area","attack_type"]
		var moves = ["mobility","move_area","move_type"]
		var hide = false
		match card_type:
			DataEnums.CardType.SPELL:
				hide = property.name == "health" || property.name == "exclusive" || attacks.has(property.name) || moves.has(property.name)
			DataEnums.CardType.TERRAIN:
				hide = attacks.has(property.name) || moves.has(property.name)
			DataEnums.CardType.CHARACTER:
				hide = property.name == "exclusive"
		if hide:
			_property_usages[property.name] = property.usage
			property.usage = PROPERTY_USAGE_NO_EDITOR
		else:
			property.usage = _property_usages[property.name]
