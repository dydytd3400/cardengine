## 是否敌对
## 隐含条件：左侧为Card类型，右侧为right
class_name ConditionIsEnemy extends Condition

func evaluate(left,right)->bool:
	return left && left.is_enemy(right)
