extends Resource
class_name Ability

var owner_card: Card
var triggers: Array[Trigger]
var filters: Array
var effects: Array[Effect]
var before_effect_count: int = 0
var when_effect_count: int = 0
var after_effect_count: int = 0
var enable: bool = true


func execute() -> void:
	if !enable:
		return
	# TODO 目前目标来源仅只有卡牌 获取可增加诸如Player/Ability等其他目标来源
	# 通过卡牌获取生效目标插槽
	var targets: Array = []
	for filter in filters:
		if filter != null:
			targets.append_array(filter.filter(owner_card))

	# 使效果在目标单位生效
	before_effect_count = effects.size()
	when_effect_count = effects.size()
	after_effect_count = effects.size()
	for effect in effects:
		effect.BEFORE_effect.connect(_complate_before)
		effect.WHEN_effect.connect(_complate_when)
		effect.AFTEL_effect.connect(_complated_after)
		#effect.execute(owner_card, targets)


func _complate_before():
	before_effect_count -= 1
	if before_effect_count == 0:
		complated_before()
	if before_effect_count < 0:
		before_effect_count = 0


func _complate_when():
	when_effect_count -= 1
	if when_effect_count == 0:
		complated_when()
	if when_effect_count < 0:
		when_effect_count = 0

func disable():
	enable = false

func _complated_after():
	after_effect_count -= 1
	if after_effect_count == 0:
		complated_after()
	if after_effect_count < 0:
		after_effect_count = 0

func bind_trigger():
	for trigger in triggers:
		trigger.register(execute)


func complated_before():
	pass


func complated_when():
	pass


func complated_after():
	pass


func _init(card: Card):
	owner_card = card
