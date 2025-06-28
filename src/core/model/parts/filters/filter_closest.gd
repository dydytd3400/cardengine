class_name FilterClosest extends Filter

var astar_grid : AStarGrid2D
var start_pos
var closest={}
func filter(source,targets):
	if !targets:
		return null
	if source is Card:
		start_pos = source.slot.position
		astar_grid = source.holder.table.astar_grid
	elif source is Slot:
		start_pos = source.position
		astar_grid = source.holder.table.astar_grid
	else:
		lg.warning("TargetClosest source type error!")
		return null

	super.filter(source,targets)

	if closest.is_empty():
		return null
	var result = closest.target
	closest.clear()
	astar_grid = null
	start_pos = null
	return result

func _filter(source,target):
	var end_pos
	if target is Card:
		end_pos = target.slot.position
	elif target is Slot:
		end_pos = target.position
	else:
		lg.warning("TargetClosest target type error!")
		return false
	var path = astar_grid.get_id_path(start_pos, end_pos)
	if path.is_empty():
		return false
	if closest.is_empty() || closest.steps < path.size():
		closest.steps = path.size()
		closest.target = target
	return false
