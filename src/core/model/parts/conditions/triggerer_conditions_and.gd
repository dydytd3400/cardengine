## 复合条件And
## 当[member conditions]所有的[method evaluate]返回true时，当前[method evaluate]返回true
class_name TriggererConditionsAnd extends TriggererCondition
@export
var conditions :Array[TriggererCondition] =[]

func _evaluate(triggerer,listener=null)->bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if !cond.evaluate(triggerer,listener):
			return false
	return true
