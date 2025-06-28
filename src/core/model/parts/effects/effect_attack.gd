# 攻击效果
class_name EffectAttack extends Effect


# 攻击者节点（通常附加在这个节点上）
var attacker: CardNode = null
# 目标节点（在代码中设置）
var target: CardNode = null
# 攻击者原始位置
var original_position: Vector2 = Vector2.ZERO
# 动画状态
enum {IDLE, CHARGING, IMPACT, RETURNING}
var state = IDLE

func execute(source: Card,_triggerer,targets, _params: Dictionary={}):
	original_position = source.view.position
	attacker = source.view
	if targets:
		if targets is Array:
			for target in targets:
				if target:
					await attack(source,target)
		else :
			await attack(source,targets)
	else :
		await CoreSystem.get_tree().process_frame
	effect_finish.emit()


func attack(source_card:Card,target_card: Card):
	if state != IDLE or not target_card:
		return

	attacker = source_card.view
	target = target_card.view
	state = CHARGING

	# 计算冲击位置（在目标前方）
	var impact_position = calculate_impact_position()

	# 创建冲锋动画
	var charge_tween = attacker.create_tween()
	charge_tween.set_ease(Tween.EASE_OUT)
	charge_tween.set_trans(Tween.TRANS_CUBIC)
	charge_tween.tween_property(attacker, "position", impact_position, 0.2)
	charge_tween.tween_callback(_on_impact_reached.bind(source_card,target_card))

# 计算冲击位置（目标前方一定距离）
func calculate_impact_position() -> Vector2:
	if not target:
		return original_position

	# 计算冲击偏移（向目标方向移动，但停在目标前方）
	var direction = (target.global_position - attacker.global_position).normalized()
	var impact_offset = direction * 30  # 冲击距离

	# 确保不会穿过目标
	var distance_to_target = attacker.global_position.distance_to(target.global_position)
	if impact_offset.length() > distance_to_target - 10:
		impact_offset = direction * (distance_to_target - 10)

	return original_position + impact_offset

func _on_impact_reached(source_card:Card,target_card: Card):
	if state != CHARGING:
		return

	state = IMPACT

	target_card.health = target_card.health - source_card.attack # 伤害结算
	if target_card.resist_able:# 目标反击
		source_card.health = source_card.health - target_card.attack

	# 触发目标受击效果
	take_damage()

	# 创建短暂停顿（模拟冲击效果）
	await attacker.get_tree().create_timer(0.1).timeout

	# 开始返回动画
	state = RETURNING
	var return_tween = attacker.create_tween()
	return_tween.set_ease(Tween.EASE_IN_OUT)
	return_tween.set_trans(Tween.TRANS_QUAD)
	return_tween.tween_property(attacker, "position", original_position, 0.3)
	return_tween.tween_callback(_on_return_complete)

func _on_return_complete():
	state = IDLE

func take_damage():
	# 创建受击动画（震动+变红）
	var shake_tween = target.create_tween()
	shake_tween.set_parallel(true)

	# 震动效果
	var shake_amount = 5.0
	shake_tween.tween_property(target, "position", target.position + Vector2(-shake_amount, 0), 0.05)
	shake_tween.tween_property(target, "position", target.position + Vector2(shake_amount, 0), 0.05).set_delay(0.05)
	shake_tween.tween_property(target, "position", target.position + Vector2(0, -shake_amount), 0.05).set_delay(0.10)
	shake_tween.tween_property(target, "position", target.position, 0.05).set_delay(0.15)

	## 变红效果
	#var sprite = $Sprite2D  # 假设有一个Sprite2D子节点
	#if sprite:
		#var original_color = sprite.modulate
		#var hit_color = Color(1.0, 0.3, 0.3)
#
		#shake_tween.tween_property(sprite, "modulate", hit_color, 0.05)
		#shake_tween.tween_property(sprite, "modulate", original_color, 0.15).set_delay(0.05)
