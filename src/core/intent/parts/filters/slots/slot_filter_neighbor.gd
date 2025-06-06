extends SlotFilter
## 相邻的
class_name SlotFilterNeighbor

# func _on_filter(card: Card)->Array[Slot]:
# 	var player: Player              = card.get_player()
# 	var slot: Slot              = card.slot
# 	var neighbor: Dictionary        = ObjectUtil.get_neighbor_indices(slot.index, player.controller._rows, player.controller._colums)
# 	var step_slots :Array[Slot] = []
# 	for dir in neighbor:
# 		var pos = neighbor[dir]
# 		if pos>-1:
# 			step_slots.append(player.controller.slots[pos])
# 	return step_slots
# 	#return [card.get_player().controller.nearby(card,card.is_enemy())]
