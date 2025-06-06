extends Object
class_name Trigger

var owner_ability: Ability
# var trigger_type: Enums.TriggerType
var trigger_name: String
var trigger_target_filters: Array[CardFilter]


func _init(ability: Ability):
	owner_ability = ability

#	TODO 初始化时即注册，则代表初始化时即已经通过trigger_target_filters筛选出了触发目标，但触发后，此前筛选的触发目标不一定是初始化时的标定目标
func register(callback: Callable) -> void:
	if trigger_target_filters == null || trigger_target_filters.size() == 0:
		return
	#logs.i("注册触发器：  "+ trigger_name)
	# 拼接信号前缀
	var type
	# match trigger_type:
	# 	Enums.TriggerType.BEFORE:
	# 		type = "BEFORE_"
	# 	Enums.TriggerType.WHEN:
	# 		type = "WHEN_"
	# 	Enums.TriggerType.AFTER:
	# 		type = "AFTER_"
	# 	_:
	# 		return
	# 获取触发目标
	var trigger_targets: Array[Card] = []
	for trigger_target_filter in trigger_target_filters:
		if trigger_target_filter != null:
			trigger_targets.append_array(trigger_target_filter.filter(owner_ability.owner_card))
	# 监听触发目标信号
	for trigger_target in trigger_targets:
		trigger_target.connect(type+trigger_name, callback)
