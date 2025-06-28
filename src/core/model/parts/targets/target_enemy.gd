class_name TargetEnemy extends Target

func _find_target(source,_triggerer):
	if source is Player:
		return source.enemy
	if source is Slot && source.occupier:
		return source.occupier.slots
	if source is Card:
		return source.holder.plays
	lg.warning("Unknow source type")
	return null
