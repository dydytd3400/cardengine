class_name Filter extends Resource

@export
var condition:Condition

func filter(source,targets):
	var result
	if targets:
		result = []
		if targets is Array:
			for target in targets:
				if _filter(source,target) && (!condition || condition.evaluate(source,target)):
					result.append(target)
		elif _filter(source,targets) && (!condition || condition.evaluate(source,targets)):
			result = targets
	return result

func _filter(source,target):
	return true
