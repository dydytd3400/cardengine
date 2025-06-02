## 回合操作流程
class_name ActionProcess extends BaseStateMachine

const INITIAL:String = "initial"
const DRAWCARD: String  = "drawcard"
const DISCARD: String   = "discard"
const OFFENSIVE: String = "offensive"
const ENDTURN: String   = "endturn"


func _init():
	add_state(INITIAL, ActionProcessInitialState.new())
	add_state(DRAWCARD, ActionProcessDrawcardState.new())
	add_state(DISCARD, ActionProcessDiscardState.new())
	add_state(OFFENSIVE, ActionProcessOffensiveState.new())
	add_state(ENDTURN, ActionProcessEndturnState.new())
