extends Ability
class_name AbilityMove

func _init(card: Card):
	super._init(card)
	triggers = [TriggerMove.new(self)]
	effects = [EffectMove.new()]
	filters = [SlotFilterNeighbor.new([SlotConditionEmpty.new()])]


func complated_before():
	pass

func complated_when():
	owner_card.WHEN_move.emit()


func complated_after():
	owner_card.AFTER_move.emit()
