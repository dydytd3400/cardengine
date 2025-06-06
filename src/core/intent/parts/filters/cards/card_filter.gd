extends Object
class_name CardFilter

var _conditions: Array[CardCondition]


func _init(conditions: Array[CardCondition]=[]):
	_conditions = conditions


func filter(source: Card)->Array[Card]:
	var cards: Array[Card] = _on_filter(source)
	if !_conditions:
		return cards
	var ret_cards: Array[Card] = []
	for card in cards:
		for cond in _conditions:
			if cond.check(source, card):
				ret_cards.append(card)
	return ret_cards

func _on_filter(_card: Card)->Array[Card]:
	return []
