@icon("res://assets/textures/blank_blue.png")
extends PercentMarginContainer
class_name SlotNode

var cards:Array[CardNode] = []
var speed = 100

## 添加后会自动向中心移动
func add_from_hand(card:CardNode):
	cards.append(card)
	NodeUtil.add_by_local($Slot,card)

func add_from_slot(card:CardNode):
	cards.append(card)
	NodeUtil.add_by_local($Slot,card)

func remove_card(card:CardNode):
	if !card:
		lg.final("CardNode is empty!")
		return
	var find = cards.find(card)
	if find<0:
		lg.final("CardNode not exsit!")
		return
	cards.remove_at(find)
	$Slot.remove_child(card)


func _process(delta: float) -> void:
	var children =$Slot.get_children()
	var be_removes = ObjectUtil.find_array_difference(children,cards)
	var be_adds = ObjectUtil.find_array_difference(cards,children)
	if be_removes && !be_removes.is_empty():
		for card in be_removes:
			$Slot.remove_child(card)
	if be_adds && !be_adds.is_empty():
		for card in be_adds:
			NodeUtil.add_by_local($Slot,card)

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
