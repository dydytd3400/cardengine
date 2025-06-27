class_name TargetFilterPlayerAll extends TargetFilter

func _filter(source):
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
