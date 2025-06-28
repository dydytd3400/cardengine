# 攻击效果
class_name EffectAttack extends Effect

signal attack_once

# 攻击者节点（通常附加在这个节点上）
var attacker: CardNode = null
# 目标节点（在代码中设置）
var target: CardNode = null
# 攻击者原始位置
var original_position: Vector2 = Vector2.ZERO
# 动画状态
enum {IDLE, CHARGING, IMPACT, RETURNING}

func execute(source: Card,_triggerer,targets, _params: Dictionary={}):
	await CoreSystem.get_tree().process_frame
	original_position = source.view.position
	attacker = source.view
	if targets:
		if targets is Array:
			if !targets.is_empty():
				for target in targets:
					if target:
						await attack(source,target)
			else:
				lg.info("卡牌: %s 无可攻击目标" % source.card_name,{},TAG,lg.LogLevel.FATAL)
				await CoreSystem.get_tree().process_frame
		else :
			await attack(source,targets)
	else:
		lg.info("卡牌: %s 无可攻击目标" % source.card_name,{},TAG,lg.LogLevel.FATAL)
		await CoreSystem.get_tree().process_frame
	effect_finish.emit()


func attack(source_card:Card,target_card: Card):
	if  !target_card:
		return

	attacker = source_card.view
	target = target_card.view

	# 计算冲击位置（在目标前方）
	var impact_position = calculate_impact_position()

	# 创建冲锋动画
	var charge_tween = attacker.create_tween()
	charge_tween.set_ease(Tween.EASE_OUT)
	charge_tween.set_trans(Tween.TRANS_CUBIC)
	charge_tween.tween_property(attacker, "position", impact_position, 0.2)
	charge_tween.tween_callback(_on_impact_reached.bind(source_card,target_card))
	await attack_once


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

	target_card.take_damage(source_card.attack)
	if target_card.resist_able:# 目标反击
		source_card.take_damage(target_card.attack)

	# 触发目标受击效果
	take_damage()

	# 创建短暂停顿（模拟冲击效果）
	await attacker.get_tree().create_timer(0.1).timeout

	# 开始返回动画
	var return_tween = attacker.create_tween()
	return_tween.set_ease(Tween.EASE_IN_OUT)
	return_tween.set_trans(Tween.TRANS_QUAD)
	return_tween.tween_property(attacker, "position", original_position, 0.3)
	return_tween.tween_callback(_on_return_complete)

func _on_return_complete():
	attack_once.emit()

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
