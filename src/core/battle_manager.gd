extends Node
class_name BattleManager

var players:Array[Player] = []
var first_index = -1:
	set(value):
		first_index = value
		current_player_index = value
var current_player_index = -1
var current_player:Player:
	get():return players[current_player_index]
var turn_count = -1

func next() -> Player:
	var next_player = players[0] if players[0] != current_player else players[1]
	current_player_index = next_player.id
	return current_player

func _ready() -> void:
	var config = {
		"key" = "battle_process",
		"nodes" = [{
				"key" = "battle_initial",
				"executor" = "res://src/core/processes/battle_initial.gd"
			},{
				"key" = "pick_first",
				"executor" = "res://src/core/processes/pick_first.gd"
			},{
				"key" = "first_draw",
				"executor" = "res://src/core/processes/initial_hand.gd"
			},{
				"key" = "second_draw",
				"executor" = "res://src/core/processes/initial_hand.gd"
			},{
				"key" = "turn_during",
				"executor" = "res://src/core/processes/turn_during.gd"
			},{
				"key" = "checkmate",
				"executor" = "res://src/core/processes/checkmate.gd",
				"router" = "res://src/core/processes/checkmate_router.gd"
			}
		]
	}
	var process: ProcessTask = ProcessTemplate.new().generate(config)
	process.enter({ manager=self})

func _default_module_loader(type:String,key:String,module_config:Dictionary)->Variant:
	if type=="executor":
		var executor
		match(key):
				"battle_initial":
					executor = BattleInitial.new()
				"pick_first":
					executor = PickFirst.new()
				"first_draw":
					executor = InitalHand.new()
				"second_draw":
					executor = InitalHand.new()
				"turn_during":
					executor = TurnDuring.new()
				"checkmate":
					executor = Checkmate.new()
		if executor:
			executor.battle_manager = self
			return executor
	if type=="router":
		var router
		match(key):
				"checkmate":
					router = CheckmateRouter.new()
		if router:
			return router

	var resource:String = module_config.resource
	if !resource || resource.is_empty():
		lg.fatal("Template %s empty!" % type)
		return null
	var module = load(resource).new()
	for param in module_config.keys():
		if param != "resource":
			module[param] = module_config[param]
	return module
