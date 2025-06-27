## 复合条件Not
## 当[member conditions]所有的[method filter]返回false时，当前[method filter]返回true
class_name TriggererConditionsNot extends TriggererConditionsAnd

func _evaluate(triggerer,listener=null)->bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if cond.evaluate(triggerer,listener):
			return false
	return true
