extends SlotFilter
class_name SlotFilterForword

func _on_filter(card: Card)->Array[Slot]:
    return [card.get_player().controller.nearby(card,card.is_enemy())]
