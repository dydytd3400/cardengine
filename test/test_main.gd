extends Node2D


func _init():
	var process: ProcessTask = ProcessTemplate.new(ProcessConfigV2.battle).generate()
	process.enter()
