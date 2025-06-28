class_name Target extends Resource

@export
var condition:Condition
@export
var filter:Filter

func find_target(source,triggerer):
	var targets
	var result =  _find_target(source,triggerer)
	if result:
		if result is Array:
			targets = []
			for item in result:
				if !condition || condition.evaluate(source,item):
					targets.append(item)
		else:
			if !condition || condition.evaluate(source,result):
				targets = result
	if filter:
		return filter.filter(source,targets)
	return targets

func _find_target(_source,_triggerer):
	return null
