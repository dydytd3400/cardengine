extends CardFilter
class_name CardFilterSelfDeck

func _on_filter(card: Card)->Array[Card]:
	return card.get_player()._deck._cards
