extends ProcessTaskExecutor
class_name PlayCard


func _execute(task: ProcessTask, msg: Dictionary = {}):
	var battle_field: BattleField = msg.battle_field
	var player: Player = battle_field.current_player
	player.play_card()
	completed(task, msg)
