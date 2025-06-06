extends Trigger
class_name TriggerAttack

func _init(ability: Ability):
	super._init(ability)
	trigger_name = "attack"
	# trigger_type = Enums.TriggerType.BEFORE
	trigger_target_filters = []
