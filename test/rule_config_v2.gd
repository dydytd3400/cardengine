## 流程配置字典
## <必填> 必填项，否则抛出异常
## <可选> 可选项
## [...] ...为默认值
class_name ProcessConfigV2 extends RefCounted

## 战斗流程
const battle: Dictionary = {
	"name" = "战斗流程",
	"key" = "battle_process",
	"disable" = 0,
	"sortable" = false,
	"tips" = "",
	"nodes" = [{
			"name"= "战斗准备",
			"key" = "battle_initial",
			"executor" = "res://src/core/process_system/process_task_executor.gd"
		},{
			"name" = "确定先手",
			"key" = "pick_first",
			"executor" = "res://src/core/process_system/process_task_executor.gd",
			"nodes" = [{
					"name"= "回合准备",
					"key" = "turn_initial",
					"executor" = "res://src/core/process_system/process_task_executor.gd"
				},{
					"name" = "回合动作",
					"key" = "turn_pick_first",
					"executor" = {
						"resource" = "res://src/core/process_system/process_task_executor_timer.gd",
						"duration" = 2,
						"loop" = true,
						"repeat" = 5
					}
				}
			]
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
