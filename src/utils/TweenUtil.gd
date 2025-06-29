class_name TweenUtil

static func scale_to(node: Control, duration: float, scale: Vector2,finished : Callable = func (): return )->Signal:
	var tween: Tween = node.create_tween();
	tween.tween_property(node, "scale", scale, duration)
	tween.tween_callback(finished)
	return tween.finished

static func size_to(node: Control, duration: float, size: Vector2,finished : Callable = func (): return )->Signal:
	var tween: Tween = node.create_tween();
	tween.tween_property(node, "size", size, duration)
	tween.tween_callback(finished)
	return tween.finished

static func size_by_x(node: Control, duration: float, x: int,finished : Callable = func (): return )->Signal:
	var size: Vector2 = Vector2(node.get_size())
	size.x += x
	return size_to(node, duration, size,finished)


static func size_by_y(node: Control, duration: float, y: int,finished : Callable = func (): return )->Signal:
	var size: Vector2 = Vector2(node.get_size())
	size.y += y
	return size_to(node, duration, size,finished)

static func move_to(node: Node, duration: float, position: Vector2,finished : Callable = func (): return )->Tween:
	var tween: Tween = node.create_tween();
	tween.tween_property(node, "position", position, duration)
	tween.tween_callback(finished)
	return tween


static func move_by_x(node: Node, duration: float, x: int,finished : Callable = func (): return )->Tween:
	var position: Vector2 = Vector2(node.get_position())
	position.x += x
	return move_to(node, duration, position,finished)


static func move_by_y(node: Node, duration: float, y: int,finished : Callable = func (): return )->Tween:
	var position: Vector2 = Vector2(node.get_position())
	position.y += y
	return move_to(node, duration, position,finished)

static func alpha_to(node: Control, duration: float, alpha: float,finished : Callable = func (): return  )->Signal:
	var tween: Tween = node.create_tween();
	tween.tween_property(node, "modulate:a", alpha, duration)
	tween.tween_callback(finished)
	return tween.finished


static func alpha_by(node: Control, duration: float, alpha: int,finished : Callable = func (): return )->Signal:
	var position: Vector2 = Vector2(node.get_size())
	position.x += alpha
	return size_to(node, duration, position,finished)


static func spawn(node: Node, initial_scale: float = 1, initial_rotation = 0, shadow: Node = null)->Tween:
	# 重置初始状态
	node.scale = Vector2.ZERO
	node.rotation_degrees = randf_range(-25, 25)
	node.modulate.a = 0.0

	#	Tween.EASE_OUT_BOUNCE
	# 创建补间动画
	var tween: Tween = node.create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BACK)
	# 主缩放动画
	tween.tween_property(node, "scale", initial_scale, 0.8)
	# 旋转复位
	tween.parallel().tween_property(node, "rotation_degrees", initial_rotation, 0.6)
	# 淡入效果
	tween.parallel().tween_property(node, "modulate:a", 1.0, 0.5)
	# 动态阴影（需预设阴影节点）
	if shadow != null:
		shadow.modulate.a = 0.5
		tween.parallel().tween_property(shadow, "modulate:a", 0.2, 0.6)
	return tween
