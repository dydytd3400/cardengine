extends SlotCondition
class_name SlotConditionEmpty

func _on_check(_source:Card,slot:Slot)->bool:
	return slot.is_empty()
