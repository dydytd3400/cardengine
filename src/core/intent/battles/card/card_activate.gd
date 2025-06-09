extends ProcessTaskExecutor
class_name CardActivate

func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	lg.info("卡牌: %s 开始激活" % card.card_name,{},"BattleProcess")
	card.to_activate()
	completed(task,msg)
