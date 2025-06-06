extends SlotFilter
class_name SlotFilterAll

func _on_filter(card: Card) -> Array[Slot]:
	return card.get_player().controller.slots
