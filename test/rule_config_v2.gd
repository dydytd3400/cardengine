## 流程配置字典
## <必填> 必填项，否则抛出异常
## <可选> 可选项
## [...] ...为默认值
class_name ProcessConfigV2 extends RefCounted

## 战斗流程
const battle: Dictionary = {
	"name" = "战斗流程",																			# 当前节点显示名称 <必填>
	"key" = "battle_process",																	# 当前节点ID <必填>
	"disable" = 0, 																				# 当前节点是否禁用 0:不可禁用 1:禁用 -1:启用 <可选> [0]
	"sortable" = false,																			# 当前节点是否允许被排序 <可选> [false]
	"tips" = "",																					# 当前节点描述 <可选> [null]
	"nodes" = [{																				# 当前节点的子节点 <可选> [空]
			"name"= "战斗准备",
			"key" = "initial",
			"executor" = "res://src/core/process_system/process_task_executor.gd"
		},{
			"name" = "确定先手",
			"key" = "pick_first",
			"executor" = "res://src/core/process_system/process_task_executor.gd"
		},{
			"name" = "回合进行",
			"key" = "turn_during",
			"nodes" = [{
					"name"= "回合准备",
					"key" = "turn_initial",
					"executor" = "res://src/core/process_system/process_task_executor.gd"
				},{
					"name" = "回合动作",
					"key" = "turn_pick_first",
					"executor" = "res://src/core/process_system/process_task_executor.gd"
				}
			]
		},{
			"name" = "回合完成",
			"key" = "turn_finish",
			"executor" = "res://src/core/process_system/process_task_executor.gd"
		},{
			"name" = "分出胜负",
			"key" = "checkmate",
			"executor" = "res://src/core/process_system/process_task_executor.gd"
		},
	]
}
