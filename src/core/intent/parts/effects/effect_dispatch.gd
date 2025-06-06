extends Effect
# 出兵效果
class_name EffectDispatch

# var controller:TableController

# func execute(_source: Card, _targets: Array):
# 	source=_source
# 	_to_slot(_targets)
# 	controller = _source.get_player().controller
# 	_before_dispatch()

# #开始派遣动作
# func _before_dispatch():
# 	BEFORE_effect.emit()
# 	var tween: Tween = source.create_tween().set_parallel(true)  # 并行执行
# 	# X轴弹性动画
# 	tween.tween_property(source, "scale:x", 1.2, 0.1).set_trans(Tween.TRANS_BOUNCE)
# 	tween.tween_property(source, "scale:x", 1.0, 0.3)
# 	# Y轴弹性动画（反向）
# 	tween.tween_property(source, "scale:y", 0.8, 0.1).set_trans(Tween.TRANS_BOUNCE)
# 	tween.tween_property(source, "scale:y", 1.0, 0.3)
# 	tween.tween_callback(_when_dispatch)  # 可选结束回调


# #执行派遣动作 并结算
# func _when_dispatch():
# 	WHEN_effect.emit()
# 	if target_slot:
# 		var card: Card = source.get_player()._deck.draw_card()
# 		await target_slot.add_card(card,CardGroup.FromType.CARD,source)
# 		# 派遣反馈 派遣方震动
# #		await _shake_effect(target_slot.card).finished
# 	_afterl_dispatch()


# #派遣动作完成 通知上层
# func _afterl_dispatch():
# 	AFTEL_effect.emit()


# # 派遣/受击表现
# func _shake_effect(_target: Card) -> Tween:
# 	var shake_tween: Tween = create_tween()
# 	# 小幅度快速震动（向下偏移10像素，再返回）
# 	shake_tween.tween_property(_target, "position", _target.position + Vector2(0, 10), 0.1)
# 	shake_tween.tween_property(_target, "position", _target.position, 0.1)
# 	return shake_tween
