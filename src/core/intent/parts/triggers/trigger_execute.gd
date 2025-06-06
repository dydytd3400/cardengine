extends Trigger
class_name TriggerExecute

func _init(ability: Ability):
	super._init(ability)
	trigger_name = "execute"
	# trigger_type = Enums.TriggerType.BEFORE
	trigger_target_filters = [CardFilterCurrent.new()]
