extends Resource
class_name Ability

@export
var trigger: Trigger
@export
var filter: TargetFilter
@export
var effect: Effect
@export
var enable: bool = true

func initialize(source) -> void:
	trigger.triggered.connect(execute.bind(source))

func execute(triggerer , msg : Dictionary,source) -> void:
	if !enable:
		return
	var targets = filter.filter(source)
	effect.execute( source,triggerer,targets,msg)
