class_name BattleFieldNode
extends Node

var battle_field: BattleField = BattleField.new()

func _ready() -> void:
	var root = "res://src/core/intent/battles/%s.gd"
	var config = {
		"key" = "对战流程",
		"nodes" = [ {
				"key" = "战场初始化",
				"executor" = root % "battle_initial"
			}, {
				"key" = "决出先手玩家",
				"executor" = root % "pick_first"
			}, {
				"key" = "初始化手牌",
				"concurrent" = true,
				"nodes" = [ {
						"key" = "先手玩家抽牌",
						"executor" = {
							"resource" = root % "player/draw_card",
							"count" = 3,
							"source_player_type" = "current_player",
							"source_cards_type" = "deck",
							"target_player_type" = "current_player",
							"target_cards_type" = "hand"
						}
					}, {
						"key" = "后手玩家抽牌",
						"executor" = {
							"resource" = root % "player/draw_card",
							"count" = 4,
							"source_player_type" = "next_player",
							"source_cards_type" = "deck",
							"target_player_type" = "next_player",
							"target_cards_type" = "hand"
						}
					}]
			}, {
				"key" = "回合流程",
				"nodes" = [ {
						"key" = "回合初始化数据", # 通常用于
						"executor" = root % "turn_initial",
					}, {
						"key" = "发放利息",
						"executor" = root % "player/interest_payout",
					}, {
						"key" = "补充手牌",
						"executor" = root % "player/draw_card",
					},
					 {
					 	"key" = "牌桌流程",
					 	"executor" = {
					 		"resource" = "res://addons/godot_core_system/source/process_system/process_task_executor_launcher.gd",
					 		"context_key" = "card",
					 		"context_values" = "@context{battle_field.current_player.plays}",
					 		"process" = {
					 			"key" = "卡牌行动",
					 			"nodes" = [ {
					 				"key" = "激活",
					 				"executor" = root % "card/card_activate",
					 			},{
					 				"key" = "移动",
					 				"executor" = root % "card/card_move",
					 			}, {
					 				"key" = "攻击",
					 				"executor" = root % "card/card_attack",
					 			}]
					 		},
					 	}
					 },
					{
						"key" = "出牌",
						"executor" = root % "player/play_card"
					}
				]
			}, {
				"key" = "回合结束胜负判定",
				"executor" = root % "checkmate",
				"router" = {
					"resource" = "res://addons/godot_core_system/source/process_system/process_task_router_match.gd",
					"routers" = [{
						"matcher" = "@context{battle_field}.checkmate()",
						"回合流程" = false
					} ]
				}
			}],
		"monitor" = ""
	}
	var process: ProcessTask = ProcessTemplate.new().generate(config)
	process.enter({"battle_field" = battle_field})

# func _default_module_loader(type: String, key: String, module_config: Dictionary) -> Variant:
# 	if type == "executor":
# 		var executor
# 		match (key):
# 				"battle_initial":
# 					executor = BattleInitial.new()
# 				"pick_first":
# 					executor = PickFirst.new()
# 				"first_draw":
# 					executor = DrawCard.new()
# 				"second_draw":
# 					executor = DrawCard.new()
# 				"turn_during":
# 					executor = TurnDuring.new()
# 				"checkmate":
# 					executor = Checkmate.new()
# 		if executor:
# 			executor.battle_field = self
# 			return executor
# 	if type == "router":
# 		var router
# 		match (key):
# 				"checkmate":
# 					router = CheckmateRouter.new()
# 		if router:
# 			return router

# 	var resource: String = module_config.resource
# 	if !resource || resource.is_empty():
# 		lg.fatal("Template %s empty!" % type)
# 		return null
# 	var module = load(resource).new()
# 	for param in module_config.keys():
# 		if param != "resource":
# 			module[param] = module_config[param]
# 	return module
