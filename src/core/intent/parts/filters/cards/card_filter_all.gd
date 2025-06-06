extends CardFilter
class_name CardFilterAll

func _on_filter(card: Card) -> Array[Card]:
	return card.get_player().cards + card.get_player().enemy().cards
