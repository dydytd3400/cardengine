extends Ability
class_name AbilityAttack

#func _init():
	#triggers = [TriggerExecute.new(self)]
	#effects = [EffectAttack.new()]


#func complated_before():
	#owner_card.BEFORE_attack.emit()
#
#
#func complated_when():
	#owner_card.WHEN_attack.emit()
	#owner_card.WHEN_execute.emit()
#
#
#func complated_after():
	#owner_card.AFTER_attack.emit()
	#owner_card.AFTER_execute.emit()
