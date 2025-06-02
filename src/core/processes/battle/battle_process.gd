## 战斗流程
class_name BattleProcess extends BaseStateMachine

const INITIAL: String     = "initial"
const PICK_FIRST: String  = "pick_first"
const TURN_DURING: String = "turn_during"
const TURN_FINISH: String = "turn_finish"
const CHECKMATE: String   = "checkmate"


func _init():
	add_state(INITIAL, BattleProcessInitialState.new())
	add_state(PICK_FIRST, BattleProcessPickfirstState.new())
	add_state(TURN_DURING, BattleProcessTurnDuringState.new())
	add_state(TURN_FINISH, BattleProcessTurnFinishState.new())
	add_state(CHECKMATE, BattleProcessCheckmateState.new())
