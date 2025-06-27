class_name TriggererConditionAself extends TriggererCondition

func _evaluate(triggerer,listener=null)->bool:
	return triggerer && triggerer == listener
