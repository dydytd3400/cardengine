extends Resource
class_name Ability

var trigger: Trigger
var filters: Array
var effect: Effect
var enable: bool = true


func execute(owner: Card, triggerer = null, target = null) -> void:
	effect.execute(owner)


func card_behavioral_recognition(owner: Card, triggerer: Card, behavior: StringName, factor: Dictionary) -> void:
	if !enable:
		return

func player_behavioral_recognition(owner: Card, triggerer: Player, behavior: StringName, factor: Dictionary) -> void:
	if !enable:
		return

func system_behavioral_recognition(owner: Card, behavior: StringName, factor: Dictionary) -> void:
	if !enable:
		return
