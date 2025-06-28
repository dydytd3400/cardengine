class_name TargetAttackArea extends Target

func _find_target(source:Card,_triggerer):
	if source is Card && source.attack_area && !source.attack_area.is_empty():
		var map = source.holder.table.slots_matrix
		var targets = []
		for pos in source.attack_area:
			var target_pos = source.slot.position + pos
			if is_valid_position(target_pos,map):
				var cards = map[target_pos.y][target_pos.x].cards
				if cards && !cards.is_empty():
					targets.append(cards[0])
		return targets
	lg.warning("Unknow source type")
	return null


## 检查位置是否在地图范围内
func is_valid_position(pos: Vector2i, map: Array) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.y < map.size() and pos.x < map[0].size()
