## 复合条件Or
## 当[member conditions]中的任意一个[method evaluate]返回true时，当前[method evaluate]返回true
class_name TriggererConditionsOr extends TriggererConditionsAnd

func _evaluate(triggerer,listener=null)->bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if cond.evaluate(triggerer,listener):
			return true
	return false
