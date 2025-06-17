extends Resource
class_name Ability

var triggers: Array[Trigger]
var filters: Array
var effects: Array[Effect]
var enable: bool = true


func execute(owner: Card,trigger=null,target=null) -> void:
	for effect in effects:
		effect.execute(owner)
