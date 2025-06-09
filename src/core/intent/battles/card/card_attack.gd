extends ProcessTaskExecutor
class_name CardAttack

func _execute(task: ProcessTask, msg: Dictionary = {}):
	var card:Card = msg.card
	lg.info("卡牌: %s 开始攻击" % card.card_name,{},"BattleProcess")
	card.to_attack()
	completed(task,msg)
