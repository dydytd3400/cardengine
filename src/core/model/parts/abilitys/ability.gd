class_name Ability
extends Resource

signal ability_finish
@export
var trigger: Trigger
@export
var target_filter: Target
@export
var triggerer_condition: Condition
@export
var effect: Effect
@export
var enable: bool = true


func initialize(source) -> void:
	trigger.triggered.connect(execute.bind(source))


func execute(triggerer, msg: Dictionary, source) -> void:
	if enable && triggerer_condition.evaluate(triggerer, source):
		var targets = target_filter.find_target(source, triggerer)
		if targets:
			effect.execute(source, triggerer, targets, msg)
			await effect.effect_finish
		else:
			await CoreSystem.get_tree().physics_frame
	ability_finish.emit()
