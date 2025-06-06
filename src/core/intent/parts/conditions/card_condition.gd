extends Object
class_name CardCondition

var negation:bool = false

func _init(_negation:bool = false):
    negation=_negation

func check(source:Card,target:Card)->bool:
    var success: bool = _on_check(source,target)
    return !success if negation else success


func _on_check(source:Card,target:Card)->bool:
    return false


