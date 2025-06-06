extends CardFilter
class_name CardFilterEnemyTomb

func _on_filter(card: Card)->Array[Card]:
	return card.get_player().enemy()._tomb._cards
