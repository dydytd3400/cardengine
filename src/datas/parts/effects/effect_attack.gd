# 攻击效果
class_name EffectAttack extends Effect


#var original_position


# func execute(_source: Card, _targets: Array):
# 	source=_source
# 	_to_card(_targets)
# 	original_position = _source.position
# 	_before_attack()


# #开始攻击动作
# func _before_attack():
# 	if !target_card:
# 		return
# 	BEFORE_effect.emit()
# 	# 创建 Tween 实例
# 	var tween: Tween = create_tween()
# 	tween.set_trans(Tween.TRANS_BACK)  # 弹性缓动
# 	tween.set_ease(Tween.EASE_OUT)     # 加速效果

# 	# 第一步：快速移动到节点B的位置（0.3秒）
# 	tween.tween_property(source, "position", target_card.position, 0.3)

# 	# 第二步：向下震动（小幅度快速移动）
# 	tween.tween_callback(_when_attack)  # 回调触发震动

# 	# 第三步：平滑返回原位（0.5秒）
# 	tween.tween_property(source, "position", original_position, 0.5)
# 	tween.tween_callback(_afterl_attack)  # 可选结束回调


# #执行攻击动作 并结算
# func _when_attack():
# 	if !target_card:
# 		return
# 	target_card.set_health(target_card.get_health()-source.get_attack())
# 	WHEN_effect.emit()
# 	# 攻击反馈 攻击方震动
# 	_shake_effect(source)
# 	# 受击反馈 受击方震动
# 	_shake_effect(target_card)


# #攻击动作完成 通知上层
# func _afterl_attack():
# 	AFTEL_effect.emit()


# # 攻击/受击表现
# func _shake_effect(_target: Card) -> Tween:
# 	var shake_tween: Tween = create_tween()
# 	# 小幅度快速震动（向下偏移10像素，再返回）
# 	shake_tween.tween_property(_target, "position", _target.position + Vector2(0, 10), 0.1)
# 	shake_tween.tween_property(_target, "position", _target.position, 0.1)
# 	return shake_tween
