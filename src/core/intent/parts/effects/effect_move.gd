extends Effect
# 移动效果
class_name EffectMove

func execute(source: Card, _params: Dictionary = {}):
	var slot = find_move_slot(source, source.mobility, source.move_area)
	if slot:
		move_to(source, slot)

func find_move_slot(source: Card, step: int, _area: Array[Vector2i]) -> Slot:
	var solts = source.holder.table.slots_matrix
	var attack_area := []
	# 需要先通过攻击范围确定可攻击目标
	# 在根据可攻击目标确定
	# 不对不对不对…… 优先级算法太难了……………………………………………………………………………………………………
	var moveable_area := _moveable_area(solts,_area,source.slot)
	return null

func move_to(source: Card, slot: Slot):
	slot.add_from_slot(source)

## 可移动范围
func _moveable_area(slots_matrix: Array[Array],  _area: Array[Vector2i], _slot: Slot) -> Array[Vector2i]:
	var area = []
	for item in _area:
		var pos :Vector2i = _slot.position+item
		if _is_position_valid(pos,slots_matrix) && !slots_matrix[pos.y][pos.x].exclusive:
			area.append(pos)
	return area

# 辅助函数：检查位置是否有效
func _is_position_valid(pos: Vector2i, slots_matrix: Array[Array]) -> bool:
	return pos.y >= 0 && pos.y < slots_matrix.size() && pos.x >= 0 && pos.x < slots_matrix[0].size()
