extends SlotFilter
class_name SlotFilterEnemys

func _on_filter(card: Card)->Array[Slot]:
    return card.get_player().enemy().slots
