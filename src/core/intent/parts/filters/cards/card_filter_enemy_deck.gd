extends CardFilter
class_name CardFilterEnemyDeck

func _on_filter(card: Card) -> Array[Card]:
	return card.get_player().enemy()._deck._cards
