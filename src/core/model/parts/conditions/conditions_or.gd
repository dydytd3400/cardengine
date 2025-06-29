## 复合条件Or
## 当[member conditions]中的任意一个[method evaluate]返回true时，当前[method evaluate]返回true
class_name ConditionsOr
extends ConditionsAnd

func evaluate(_left, _right) -> bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if cond.evaluate(_left, _right):
			return true
	return false
