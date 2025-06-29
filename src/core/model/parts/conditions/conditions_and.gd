## 复合条件And
## 当[member conditions]所有的[method evaluate]返回true时，当前[method evaluate]返回true
class_name ConditionsAnd
extends Condition
@export
var conditions: Array[Condition] = []


func evaluate(_left, _right) -> bool:
	if conditions.is_empty():
		return true
	for cond in conditions:
		if !cond.evaluate(_left, _right):
			return false
	return true
