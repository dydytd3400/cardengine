## 检查条件
class_name ConditionInspect extends Condition

## 检查模式
## BOTH：默认双边检查[method evaluate]的左侧参数[br]
## LEFT：仅检查[method evaluate]的左侧参数[br]
## RIGHT：仅检查[method evaluate]的右侧参数[br]
@export_enum("BOTH","LEFT", "RIGHT")
var inspect_mode = "BOTH"

func evaluate(_left, _right) -> bool:
	match inspect_mode:
		"LEFT":
			return inspect_single(_left)
		"RIGHT":
			return inspect_single(_right)
	return inspect_both(_left, _right)

func inspect_single(_target) -> bool:
	return true

func inspect_both(_left, _right) -> bool:
	return inspect_single(_left) && inspect_single(_right)
