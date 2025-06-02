## 确认先后手
class_name BattleProcessPickfirstState
extends BaseState

var first_index: int = 0


func enter(msg := {}):
	super.enter(msg)
	first_index = randi_range(0, 1)
	exit()

func exit() -> bool:
	switch_to(BattleProcess.TURN_DURING)
	return super.exit()
