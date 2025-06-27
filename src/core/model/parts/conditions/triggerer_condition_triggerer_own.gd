class_name TriggererConditionTriggererOwn extends TriggererCondition

func _evaluate(triggerer:Card,listener:Player=null)->bool:
	return triggerer && triggerer.holder == listener
