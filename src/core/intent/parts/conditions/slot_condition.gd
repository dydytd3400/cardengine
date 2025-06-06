extends Object
class_name SlotCondition

var negation:bool = false

func _init(_negation:bool = false):
    negation=_negation

func check(source:Card,slot:Slot)->bool:
    var success: bool = _on_check(source,slot)
    return !success if negation else success


func _on_check(source:Card,slot:Slot)->bool:
    return false


