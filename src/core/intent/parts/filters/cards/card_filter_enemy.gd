extends CardFilter
class_name CardFilterEnemy

func _on_filter(card: Card)->Array[Card]:
	return card.get_player().enemy().cards
