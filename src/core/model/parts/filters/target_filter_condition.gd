class_name TargetFilterCondition extends TargetFilter

var condition :TriggererCondition

func filter(source):
	if condition.evaluate(source,null):
		return source
