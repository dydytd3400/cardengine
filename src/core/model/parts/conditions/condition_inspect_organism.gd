## 生物检查
class_name ConditionInspectOrganism extends ConditionInspect

func inspect_single(target) -> bool:
	return target && target is Card && target.card_type == DataEnums.CardType.ORGANISM
