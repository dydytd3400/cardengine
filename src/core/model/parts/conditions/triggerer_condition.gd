## 触发条件
class_name TriggererCondition extends Resource

## 条件判断的检查模式
## NORMAL：默认模式，[method _evaluate]的参数包含triggerer和listener[br]，选择该模式时 不会再进行类型检查
## TRIGGERER：仅检查触发者，[method _evaluate]的参数仅包含triggerer[br]
## LISTENER：仅检查目标，[method _evaluate]的参数仅包含listener[br]
## BOTH：仅检查触发者和目标，[method _evaluate]的参数仅包含triggerer和listener
@export_enum("NORMAL","TRIGGERER","LISTENER","BOTH")
var mode = "NORMAL"
## 条件判断的参数的类型校验
## NORMAL：默认模式，不检查类型
@export_enum("NORMAL","CARD","PLAYER","SLOT")
var type = "NORMAL"

func evaluate(triggerer,listener)->bool:
	match mode:
		"TRIGGERER":
			if !evaluate_type(triggerer):
				return false
			return _evaluate(triggerer)
		"LISTENER":
			if !evaluate_type(listener):
				return false
			return _evaluate(listener)
		"BOTH":
			if !evaluate_type(triggerer,listener):
				return false
			return _evaluate(triggerer,listener)
	return _evaluate(triggerer,listener)

func evaluate_type(triggerer,listener=null)->bool:
	match type:
		"CARD":
			if !triggerer:
				lg.warning("Target is nil")
				return false
			if !(triggerer is Card):
				lg.warning("Type not is Card!")
				return false
			if mode == "BOTH":
				if !listener:
					lg.warning("Target is nil")
					return false
				if !(listener is Card):
					lg.warning("Type not is Card!")
					return false
		"PLAYER":
			if !triggerer:
				lg.warning("Target is nil")
				return false
			if !(triggerer is Player):
				lg.warning("Type not is Player!")
				return false
			if mode == "BOTH":
				if !listener:
					lg.warning("Target is nil")
					return false
				if !(listener is Player):
					lg.warning("Type not is Player!")
					return false
		"SLOT":
			if !triggerer:
				lg.warning("Target is nil")
				return false
			if !(triggerer is Slot):
				lg.warning("Type not is SLOT!")
				return false
			if mode == "BOTH":
				if !listener:
					lg.warning("Target is nil")
					return false
				if !(listener is Slot):
					lg.warning("Type not is Slot!")
					return false
	return true

func _evaluate(_triggerer,_listener=null)->bool:
	return true
