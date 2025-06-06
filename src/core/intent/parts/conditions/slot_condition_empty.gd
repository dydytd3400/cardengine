extends SlotCondition
class_name SlotConditionEmpty

func _on_check(source:Card,slot:Slot)->bool:
    return slot.is_empty()


