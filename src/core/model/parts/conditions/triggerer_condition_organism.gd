class_name TriggererConditionOrganism extends TriggererCondition

func _filter(triggerer,listener=null)->bool:
	return triggerer && triggerer is Card && triggerer.card_type == DataEnums.CardType.ORGANISM
