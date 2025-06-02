## 回合流程
class_name TurnProcess extends BaseStateMachine
const INITIAL: String = "initial"
const ACTION: String  = "action"

func _init():
	add_state(INITIAL, TurnProcessInitialState.new())
	add_state(ACTION, TurnProcessActionState.new())
