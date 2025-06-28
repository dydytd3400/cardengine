class_name TargetRange extends Target

@export
var ranges:Array[Target] = []

func _find_target(_source,_triggerer):
	if !ranges.is_empty():
		var targets = []
		for range in ranges:
			var target = range.find_target(_source,_triggerer)
			if target:
				if target is Array:
					targets.append_array(target)
				else:
					targets.append(target)
		return targets
	return null
