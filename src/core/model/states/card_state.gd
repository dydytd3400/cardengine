class_name CardState extends BaseStateMachine

const INIT = "CardStateInit"
const DECK = "CardStateDeck"
const HAND = "CardStateHand"
const TABLE = "CardStateTable"
const ACTIVATE = "CardStateactivate"
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
	add_state(ACTIVATE,BaseState.new())
	add_state(MOVE,BaseState.new())
	add_state(ATTACK,BaseState.new())
	add_state(USED,BaseState.new())
	add_state(TRASHED,BaseState.new())
