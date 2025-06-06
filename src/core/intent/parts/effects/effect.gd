extends Object
class_name Effect

signal BEFORE_effect
signal WHEN_effect
signal AFTEL_effect

var source: Card

var target_card:Card
var target_slot: Slot
var target_cards:Array[Card]
var target_slots:Array[Slot]

# 效果的目标一定是 Slot
# 因为效果自身一定知道且需要知道最终目标执行的单位是卡牌还是卡槽
# 则一定可以通过位置去获取最终目标
func execute(_source: Card, _targets: Array):
	pass


func _to_slot(_targets: Array):
	if _targets:
		var t = _targets[0]
		if t :
			if t is Slot:
				target_slot = t
			elif t is Card:
				target_slot = t.slot

func _to_card(_targets: Array):
	if _targets:
		var t = _targets[0]
		if t :
			if t is Slot:
				target_card = t.card
			elif t is Card:
				target_card = t

func _to_slots(_targets: Array):
	target_slots = []
	if _targets:
		for i in range(_targets.size()):
			var item = _targets[i]
			if item :
				if item is Slot:
					target_slots.append(item)
				elif item is Card:
					target_slots.append(item.slot)

func _to_cards(_targets: Array):
	target_cards = []
	if _targets:
		for i in range(_targets.size()):
			var item = _targets[i]
			if item :
				if item is Slot:
					target_cards.append(item.card)
				elif item is Card:
					target_cards.append(item)
