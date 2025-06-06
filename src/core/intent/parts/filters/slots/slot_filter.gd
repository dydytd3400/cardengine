extends Object
class_name SlotFilter

var _conditions: Array[SlotCondition]


func _init(conditions: Array[SlotCondition]=[]):
	_conditions = conditions


func filter(card: Card)->Array[Slot]:
	var slots: Array[Slot]     = _on_filter(card)
	if !_conditions:
		return slots
	var ret_slots: Array[Slot] = []
	for slot in slots:
		for cond in _conditions:
			if cond.check(card, slot):
				ret_slots.append(slot)
	return ret_slots

func _on_filter(_card: Card)->Array[Slot]:
	return []