class_name CardState extends BaseStateMachine

const INIT = "CardStateInit"
const DECK = "CardStateDeck"
const HAND = "CardStateHand"
const TABLE = "CardStateTable"
const MOVE = "CardStateMove"
const ATTACK = "CardStateAttack"
const USED = "CardStateUsed"
const TRASHED = "CardStateTrashed"

var card:Card

func _init(_card:Card) -> void:
	card = _card
	add_state(INIT,BaseState.new())
	add_state(DECK,BaseState.new())
	add_state(HAND,BaseState.new())
	add_state(TABLE,BaseState.new())
	add_state(MOVE,BaseState.new())
	add_state(ATTACK,BaseState.new())
	add_state(USED,BaseState.new())
	add_state(TRASHED,BaseState.new())
	state_changed.connect(_on_state_changed)
	#if _card.mobility>0 && _card.move_type && _card.move_area && !_card.move_area.is_empty():
		#


func _on_state_changed(from_state: BaseState, to_state: BaseState):
	match to_state.state_id:
		MOVE:
			if card.mobility>0 && card.move_type && card.move_area && !card.move_area.is_empty():
				card.move_type.execute(card)
