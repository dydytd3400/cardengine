extends Resource
class_name TargetFilter

func filter(source):
	var target
	if source is Array:
		target = []
		var t = _filter(source)
		if t is Array:
			target.append_array(t)
		else :
			target.append(t)
	else:
		target = _filter(source)
	return target

func _filter(_source):
	return null
