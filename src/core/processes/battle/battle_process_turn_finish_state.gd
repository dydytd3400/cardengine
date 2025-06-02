## 回合结束状态
class_name BattleProcessTurnFinishState extends BaseState

var game_over: bool = false

func enter(msg := {}):
	super.enter(msg)
	if game_over:
		switch_to(BattleProcess.CHECKMATE)
	else:
		switch_to(BattleProcess.TURN_DURING)
