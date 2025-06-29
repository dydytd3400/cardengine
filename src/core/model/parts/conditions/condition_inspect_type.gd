## 类型检查
class_name ConditionInspectType
extends ConditionInspect

## 目标的参数的类型
@export_enum("CARD", "PLAYER", "SLOT", "ARRAY", "CARDS", "PLAYERS", "SLOTS", "ARRAYS")
var type: String = "CARD"


func inspect_single(target) -> bool:
	return is_type(type, target)


func is_type(_type: String, target, nullable: bool = false) -> bool:
	if nullable && target == null:
		return false
	match _type:
		"CARD":
			return target is Card
		"PLAYER":
			return target is Player
		"SLOT":
			return target is Slot
		"ARRAY":
			return target is Array
		"CARDS":
			return is_array_type("CARD", target)
		"PLAYERS":
			return is_array_type("PLAYER", target)
		"SLOTS":
			return is_array_type("SLOT", target)
		"ARRAYS":
			return is_array_type("ARRAY", target)

	return true


func is_array_type(_type: String, targets) -> bool:
	if !(targets is Array):
		return false
	for target in targets:
		if !is_type(_type, target, true):
			return false
	return true
