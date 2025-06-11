## 流程配置字典
## <必填> 必填项，否则抛出异常
## <可选> 可选项
## [...] ...为默认值
class_name ProcessConfig extends RefCounted
const root = "res://src/core/intent/battles/%s.gd"
const battle_process_config = {
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
					"matchers" = [{
						"matcher" = "@context{battle_field}.checkmate()",
						"回合流程" = false
					} ]
				}
			}],
		"monitor" = ""
	}
