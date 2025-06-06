extends Node
class_name BattleField

var players:Array[Player] = []
var first_index = -1:
	set(value):
		first_index = value
		current_player_index = value
	get: return first_index
var current_player_index = -1
var current_player:Player:
	get():return players[current_player_index]
var turn_count = -1

func next() -> Player:
	current_player_index = 0 if current_player_index != 0 else 1
	return current_player

func _ready() -> void:
	var root = "res://src/core/intent/executors/%s.gd"
	var config = {
		"key" = "对战流程",
		"nodes" = [{
				"key" = "战场初始化",
				"executor" = root % "battle_initial"
			},{
				"key" = "随机先手玩家",
				"executor" = root % "pick_first"
			},{
				"key" = "初始化手牌",
				"concurrent" = true,
				"nodes" = [{
						"key" = "先手玩家抽牌",
						"executor" = {
							"resource"= root % "initial_hand",
							"count" = 3
						}
					},{
						"key" = "后手玩家抽牌",
						"executor" = {
							"resource"= root % "initial_hand",
							"count" = 4
						}
					}]
			},{
				"key" = "开始回合",
				"executor" = root % "turn_during",
			},{
				"key" = "回合结束胜负判定",
				"executor" = root % "checkmate",
				"router" = {
					"resource" = root % "checkmate_router",
					"continue_task" = "开始回合"
				}
			}],
		"monitor" = ""
	}
	var process: ProcessTask = ProcessTemplate.new().generate(config)
	process.enter({ battle_field=self})

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
			executor.battle_field = self
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
