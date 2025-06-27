extends Resource
class_name Trigger

signal triggered(listener,triggerer,msg:Dictionary)

@export_enum(CardState.INIT, CardState.DECK,CardState.HAND,CardState.TABLE,CardState.ACTIVATE,CardState.MOVE,CardState.ATTACK,CardState.USED,CardState.ATTACK,CardState.TRASHED)
var trigger_name: String

func on_triggered(triggerer,msg:Dictionary={}):
	triggered.emit(triggerer,msg)
