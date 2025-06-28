@icon("res://assets/textures/blank_blue.png")
extends PercentMarginContainer
class_name SlotNode

var cards:Array[CardNode] = []
var speed = 500

var adding_from_hand = []

@onready var canvas_node = $Slot/SlotCanvas

## 添加后会自动向中心移动
func add_from_hand(card:CardNode):
	cards.append(card)
	card.size.x = $Slot.size.x
	card.size.y = $Slot.size.y
	card.pivot_offset = size / 2
	NodeUtil.add_by_local(canvas_node,card)
	adding_from_hand.append(card)

func add_from_slot(card:CardNode):
	cards.append(card)
	card.size.x = $Slot.size.x
	card.size.y = $Slot.size.y
	card.pivot_offset = size / 2
	NodeUtil.add_by_local(canvas_node,card)
	await TweenUtil.move_to(card,0.25,Vector2.ZERO)

func remove_card(card:CardNode):
	if !card:
		lg.final("CardNode is empty!")
		return
	var find = cards.find(card)
	if find<0:
		lg.final("CardNode not exsit!")
		return
	cards.remove_at(find)
	canvas_node.remove_child(card)


func _process(delta: float) -> void:
	var added = []
	for card:CardNode in adding_from_hand:
		if card.position.x !=0 || card.position.y != 0:
			var direction  := Vector2.ZERO - card.position
			# 如果已经到达原点则停止移动,防止抖动误差
			if direction.length() <= 0.1:
				card.position = Vector2.ZERO
				added.append(card)
				continue
			# 计算移动距离 (速度 * 时间增量)
			var move_distance = speed * delta
			# 移动节点 (确保不会超过目标位置)
			if direction.length() <= move_distance:
				card.position = Vector2.ZERO
				added.append(card)
			else:
				card.position += direction.normalized() * move_distance
	if !added.is_empty():
		adding_from_hand = ObjectUtil.remove_all(adding_from_hand,added)
