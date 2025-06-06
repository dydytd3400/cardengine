extends CardFilter
class_name CardFilterSelfTomb

func _on_filter(card: Card)->Array[Card]:
	return card.get_player()._tomb._cards
