extends ProcessTaskExecutor
class_name Checkmate


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field:BattleField = msg.battle_field
	lg.info("第%d个回合结束" % battle_field.turn_count,{},"BattleProcess")
	if battle_field.checkmate():
		lg.info("全部流程结束啦",{},"BattleProcess")
		completed(task,msg)
	else:
		cancel(task, msg)
