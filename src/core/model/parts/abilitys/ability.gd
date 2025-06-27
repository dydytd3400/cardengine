class_name Ability extends Resource

signal ability_finish

@export
var trigger: Trigger
@export
var target_filter: TargetFilter
@export
var triggerer_condition: TriggererCondition
@export
var effect: Effect
@export
var enable: bool = true

func initialize(source) -> void:
	trigger.triggered.connect(execute.bind(source))

func execute(triggerer, msg : Dictionary,source) -> void:
	if enable && triggerer_condition.evaluate(triggerer,source):
		var targets = target_filter.filter(source,null)
		if targets:
			effect.execute(source,triggerer,targets,msg)
			await effect.effect_finish
	ability_finish.emit()
