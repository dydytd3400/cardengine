extends ProcessTaskExecutor
class_name PickFirst


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_manager = msg.manager
	battle_manager.first_index = randi_range(0,1)
	lg.info("当前先手玩家是 %s" % battle_manager.current_player.name)
	complated(task, msg)
