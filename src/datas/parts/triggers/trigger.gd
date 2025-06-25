extends Resource
class_name Trigger

signal triggered(triggerer,msg:Dictionary)

@export_enum(CardState.INIT, CardState.DECK,CardState.HAND,CardState.TABLE,CardState.ACTIVATE,CardState.MOVE,CardState.ATTACK,CardState.USED,CardState.ATTACK,CardState.TRASHED)
var trigger_name: String
@export
var triggerer_filter: ConditionFilter

func on_triggered(triggerer,msg:Dictionary={}):
	if !triggerer_filter || triggerer_filter.filter(triggerer):
		triggered.emit(triggerer,msg)
