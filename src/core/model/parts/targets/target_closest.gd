class_name TargetClosest extends Target


func find_target(source,triggerer):
	var targets = super.find_target(source,triggerer)
	if !targets:
		return null
	var astar_grid : AStarGrid2D
	var start_pos
	if source is Card:
		start_pos = source.slot.position
		astar_grid = source.holder.table.astar_grid
	elif source is Slot:
		start_pos = source.position
		astar_grid = source.holder.table.astar_grid
	else:
		lg.warning("TargetClosest source type error!")
		return null

	if targets is Array:
		if targets.is_empty():
			return null
		var end_pos
		var closest={}
		for target in targets:
			if target is Card:
				end_pos = target.slot.position
			elif target is Slot:
				end_pos = target.position
			else:
				lg.warning("TargetClosest target type error!")
				return null
			var path = astar_grid.get_id_path(start_pos, end_pos)
			if path.is_empty():
				continue
			if closest.is_empty() || closest.steps < path.size():
				closest.steps = path.size()
				closest.target = target
		if closest.is_empty():
			return null
		return closest.target
	return targets
