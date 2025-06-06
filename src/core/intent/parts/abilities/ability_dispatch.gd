extends Ability
class_name AbilityDispatch

func _init(card: Card):
	super._init(card)
	triggers = [TriggerExecute.new(self)]
	effects = [EffectDispatch.new()]
	filters = [SlotFilterForword.new([SlotConditionEmpty.new()])]

func complated_before():
	owner_card.BEFORE_dispatch.emit()
	owner_card.BEFORE_enter.emit()


func complated_when():
	owner_card.WHEN_dispatch.emit()
	owner_card.WHEN_enter.emit()
	owner_card.WHEN_execute.emit()


func complated_after():
	owner_card.AFTER_dispatch.emit()
	owner_card.AFTER_enter.emit()
	owner_card.AFTER_execute.emit()
