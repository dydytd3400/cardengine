class_name TargetPlayerAll extends Target

func _find_target(source,_triggerer):
	if source is BattleField:
		return source.players
	if source is Table:
		return source.players
	if source is Player:
		return source.table.players
	if source is Slot && source.occupier:
		return source.occupier.table.players
	if source is Card:
		return source.holder.table.players
	lg.warning("Unknow source type")
	return null
