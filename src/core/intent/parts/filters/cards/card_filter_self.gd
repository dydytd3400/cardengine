extends CardFilter
class_name CardFilterSelf

func _on_filter(card: Card)->Array[Card]:
	return card.get_player().cards
