class_name TriggerDispatcher extends Node

var table: Table
var players:Array[Player]

func initialize(_table: Table,_players:Array[Player]):
	table = _table
	players = _players
	for player in players:
		for card in player.deck:
			card.states.state_changed.connect(card_state_changed.bind(card))


func card_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Card):
	for card in table.cards:
		if card.abilitys && !card.abilitys.is_empty():
			for ability in card.abilitys:
				ability.card_behavioral_recognition(card, triggerer, _to_state.state_id, _msg)


func player_state_changed(_from_state: BaseState, _to_state: BaseState, _msg: Dictionary, triggerer: Player):
	for card in table.cards:
		if card.abilitys && !card.abilitys.is_empty():
			for ability in card.abilitys:
				ability.player_behavioral_recognition(card, triggerer, _to_state.state_id, _msg)

func sysytem_state_changed(process_id: StringName, _msg: Dictionary):
	if !table:
		return
	for card in table.cards:
		if card.abilitys && !card.abilitys.is_empty():
			for ability in card.abilitys:
				ability.sysytem_behavioral_recognition(card, process_id, _msg)
