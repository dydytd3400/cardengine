## 右侧拥有左侧
## 隐含条件：左侧为Card类型，右侧为right
class_name ConditionRightOwnLeft extends Condition

func evaluate(left:Card,right:Player)->bool:
	return left && left.holder == right
