## 可被选为目标
class_name ConditionInspectTargetable
extends ConditionInspect

func inspect_single(target) -> bool:
	return target && (target is Card || target is Slot) && target.target_able
