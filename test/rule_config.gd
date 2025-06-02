## 流程配置字典
## <必填> 必填项，否则抛出异常
## <可选> 可选项
## [...] ...为默认值
class_name ProcessConfig extends RefCounted

## 战斗流程
const battle: Dictionary = {
	"name" = "战斗流程",																			# 当前状态显示名称 <必填>
	"key" = "battle_process",																	# 当前状态ID <必填> 
	"disable" = 0, 																				# 当前状态是否禁用 0:不可禁用 1:禁用 -1:启用 <可选> [0]
	"sortable" = false,																			# 当前状态是否允许被排序 <可选> [false]
	"script" = "res://src/core/processes/battle/battle_process.gd",								# 当前状态对应的脚本 <必填> 
	"tips" = "",																					# 当前状态描述 <可选> [null]
	"status" = [{																				# 当前状态的子状态 <可选> [空]
			"name"= "战斗准备",
			"key" = "initial",
			"script" = "res://src/core/processes/battle/battle_process_initial_state.gd"
		},{
			"name" = "确定先手",
			"key" = "pick_first",
			"disable" = -1,
			"script" = "res://src/core/processes/battle/battle_process_pickfirst_state.gd"
		},{
			"name" = "回合进行",
			"key" = "turn_during",
			"script" = "res://src/core/processes/battle/battle_process_turn_during_state.gd",
			"status" = [{
					"name"= "回合准备",
					"key" = "initial",
					"script" = "res://src/core/processes/turn/turn_process_initial_state.gd"
				},{
					"name" = "回合动作",
					"key" = "pick_first",
					"script" = "res://src/core/processes/turn/turn_process_action_state.gd"
				}
			]
		},{
			"name" = "回合完成",
			"key" = "turn_finish",
			"script" = "res://src/core/processes/battle/battle_process_turn_finish_state.gd"
		},{
			"name" = "分出胜负",
			"key" = "checkmate",
			"script" = "res://src/core/processes/battle/battle_process_checkmate_state.gd"
		},
	]
}
