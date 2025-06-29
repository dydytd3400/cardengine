## 流程配置字典
class_name ProcessConfig extends RefCounted
const root:String  = "res://src/core/intent/battles/%s.gd"
const battle_process_config: Dictionary = {
		"key" = "对战流程",
		"nodes" = [ {
				"key" = "战场初始化",# 通常准备一些初始数据
				"executor" = {
					"resource" = ProcessConstant.EXECITOR_EXPRESSION,
					"expressions" = [{
						"expression" = "@context{battle_field}.initialize()",
						"finally" = "complete"
					}]
				}

			}, {
				"key" = "决出先手玩家",
				"executor" = {
					"resource" = ProcessConstant.EXECITOR_EXPRESSION,
					"expressions" = [{
						"expression" = "@context{battle_field}.pick_first()",
						"finally" = "complete"
					}]
				}
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
						"key" = "回合初始化数据",
						"executor" = root % "turn_initial",
					}, {
						"key" = "发放利息",
						"executor" = {
										"resource" = ProcessConstant.EXECITOR_EXPRESSION,
										"expressions" = [{
											"expression" = "@context{battle_field}.current_player.interest_payout(floor(@context{battle_field}.turn_count/2.0))",
											"finally" = "complete"
										}]
									}
					}, {
						"key" = "补充手牌",
						"executor" = root % "player/draw_card",
					},
					 {
					 	"key" = "牌桌流程",
					 	"executor" = {
					 		"resource" = ProcessConstant.EXECITOR_LAUNCHER,
					 		"context_key" = "card",
					 		"context_values" = "@context{battle_field.current_player.plays}",
					 		"process" = {
					 			"key" = "卡牌行动",
					 			"nodes" = [ {
					 				"key" = "激活",
									"executor" = {
													"resource" = ProcessConstant.EXECITOR_EXPRESSION,
													"expressions" = [{
														"expression" = "@context{card}.to_activate()",
														"finally" = "complete"
													}]
												}
					 			},{
					 				"key" = "移动",
					 				"executor" = {
													"resource" = ProcessConstant.EXECITOR_EXPRESSION,
													"expressions" = [{
														"expression" = "await @context{card}.to_move()",
														"finally" = "complete"
													}]
												}
					 			}, {
					 				"key" = "攻击",
					 				"executor" = {
													"resource" = ProcessConstant.EXECITOR_EXPRESSION,
													"expressions" = [{
														"expression" = "await @context{card}.to_attack()",
														"finally" = "complete"
													}]
												}
					 			}]
					 		},
					 	}
					 },
					{
						"key" = "出牌",
						"executor" = {
										"resource" = ProcessConstant.EXECITOR_EXPRESSION,
										"expressions" = [{
											"expression" = "await @context{battle_field}.current_player.play_card()",
											"finally" = "complete"
										}]
									}
					}
				]
			}, {
				"key" = "回合结束胜负判定",
				"executor" = {
					"resource" = ProcessConstant.EXECITOR_EXPRESSION,
					"expressions" = [{
						"expression" = "1 == 1",
						"finally" = "complete",
					}]
				},
				"router" = {
					"resource" = ProcessConstant.ROUTER_MATCH,
					"matchers" = [{
						"matcher" = "@context{battle_field}.checkmate()",
						"回合流程" = false
					} ]
				}
			}],
		"monitor" = ""
	}

const card_process_config :Dictionary=  {
			 			"key" = "卡牌流程",
			 			"nodes" = [ {
			 				"key" = "牌库",
			 				"executor" = root % "card/card_activate",
			 			},{
			 				"key" = "手牌",
			 				"executor" = root % "card/card_activate",
			 			},{
			 				"key" = "使用",# 选择目标
			 				"executor" = root % "card/card_activate",
			 			},{
			 				"key" = "生效",# 选择目标
			 				"executor" = root % "card/card_activate",
			 			},{
			 				"key" = "牌桌",
							"nodes" = [{
				 				"key" = "待机",
				 				"executor" = root % "card/card_attack",
				 			}, {
				 				"key" = "移动",
				 				"executor" = root % "card/card_attack",
				 			}, {
				 				"key" = "攻击",
				 				"executor" = root % "card/card_attack",
				 			}, {
				 				"key" = "死亡",
				 				"executor" = root % "card/card_attack",
				 			}]
			 			}, {
			 				"key" = "墓堆",
			 				"executor" = root % "card/card_attack",
			 			}, {
			 				"key" = "销毁",
			 				"executor" = root % "card/card_attack",
			 			}]
			 		}
