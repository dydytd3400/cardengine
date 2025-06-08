extends ProcessTaskExecutor
class_name CardMove


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	lg.info("卡牌: %s 开始移动" % card.card_name,{},"BattleProcess")
	card.to_move()
	completed(task,msg)
