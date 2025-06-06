extends Trigger
class_name TriggerMove

func _init(ability: Ability):
	super._init(ability)
	trigger_name = "move"
	# trigger_type = Enums.TriggerType.BEFORE
	trigger_target_filters = [CardFilterCurrent.new()]
