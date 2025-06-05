## 确认先后手
class_name BattleProcessPickfirstState
extends BaseState


func enter(msg := {}):
	super.enter(msg)
	exit()

func exit() -> bool:
	switch_to(BattleProcess.TURN_DURING)
	return super.exit()
