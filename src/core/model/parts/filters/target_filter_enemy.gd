class_name TargetFilterEnemy extends TargetFilter

func _filter(source):
	if source is Player:
		return source.enemy
	if source is Slot && source.occupier:
		return source.occupier.slots
	if source is Card:
		return source.holder.plays
	lg.warning("Unknow source type")
	return null
