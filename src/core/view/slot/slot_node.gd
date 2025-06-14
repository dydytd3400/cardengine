@icon("res://assets/textures/blank_blue.png")
extends PercentMarginContainer
class_name SlotNode

var cards:Array[CardNode] = []
var speed = 100

## 添加后会自动向中心移动
func hand_to_slot(card:CardNode):
	cards.append(card)

func slot_to_slot(card:CardNode):
	cards.append(card)

func remove_card(card:CardNode):
	if !card:
		lg.final("CardNode is empty!")
		return
	var find = cards.find(card)
	if find<0:
		lg.final("CardNode not exsit!")
		return
	cards.remove_at(find)

func _process(delta: float) -> void:
	var children =$Slot.get_children()
	var beremoves = ObjectUtil.find_array_difference(children,cards)
	var beadds = ObjectUtil.find_array_difference(cards,children)
	if beremoves && !beremoves.is_empty():
		for node in beremoves:
			NodeUtil.remove_from_parent(node)
	if beadds && !beadds.is_empty():
		for node in beadds:
			NodeUtil.add_by_local($Slot,node)

	for card:CardNode in $Slot.get_children():
		if card.position.x !=0 || card.position.y != 0:
			var direction  := Vector2.ZERO - card.position
			# 如果已经到达原点则停止移动,防止抖动误差
			if direction.length() <= 0.1:
				card.position = Vector2.ZERO
				continue
			# 计算移动距离 (速度 * 时间增量)
			var move_distance = speed * delta
			# 移动节点 (确保不会超过目标位置)
			if direction.length() <= move_distance:
				card.position = Vector2.ZERO
			else:
				card.position += direction.normalized() * move_distance
