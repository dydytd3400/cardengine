## 复合条件Not
## 当[member conditions]所有的[method evaluate]返回false时，当前[method evaluate]返回true
class_name ConditionsNot extends ConditionsAnd

func evaluate(_left, _right) -> bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if cond.evaluate(_left,_right):
			return false
	return true
