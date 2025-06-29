## 等于条件
class_name ConditionEqual
extends Condition

func evaluate(_left, _right) -> bool:
	return _left && _left == _right
