extends ProcessTaskExecutor
class_name Checkmate


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_manager = msg.manager
	lg.info("第%d个回合结束" % battle_manager.turn_count)
	if battle_manager.turn_count < 10:
		battle_manager.next()
		cancel(task, msg)
	else:
		lg.info("全部流程结束啦")
		complated(task,msg)
