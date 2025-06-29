## 移动效果
class_name EffectMove extends Effect

@export
var flyable = false
func execute(source: Card,_triggerer,_target, _params: Dictionary={}):
	var table = source.holder.table
	var map = table.slots_matrix
	var astar_grid:AStarGrid2D = table.astar_grid
	var attack_area = source.attack_area
	# 如果攻击范围内已经存在攻击目标 则不再移动
	for attack_vector in attack_area:
		var attack_pos = source.slot.position+attack_vector
		if astar_grid.is_in_boundsv(attack_pos) && targetable(attack_pos,source,map):
			await CoreSystem.get_tree().process_frame
			effect_finish.emit()
			return

	var path = find_move_path(source)
	await move_to(source, path)
	effect_finish.emit()

## 移动到目标位置
func move_to(source: Card, path: Array[Vector2i]):
	var map = source.holder.table.slots_matrix
	if path && !path.is_empty():
		var anim_time = 0
		for point in path:
			lg.info("卡牌: %s 即将从[%d,%d]移动到[%d,%d]" % [source.card_name,source.slot.position.x,source.slot.position.y,point.x,point.y],{},TAG)
			var slot:Slot = map[point.y][point.x]
			slot.add_from_slot(source)

		var tw:Tween
		for point in path:
			if !tw:
				tw = move_animation(source.view)
			else:
				tw.chain().tween_callback(func(): move_animation(source.view))
		await tw.finished
	else :
		lg.info("卡牌: %s 无可移动空间" % source.card_name,{},TAG,lg.LogLevel.FATAL)
		await CoreSystem.get_tree().process_frame



## 目标位置是否可以停留
func standable(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return target && target.add_able
#
## 目标位置是否可以作为攻击对象
func targetable(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return target && target.target_able && target.exterior.is_enemy(_source)

## 目标位置是否为敌对单位，无论是否为攻击目标
func is_enemy(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return target && target.exterior && target.exterior.is_enemy(_source)

## 寻找移动路径
func find_move_path(source: Card) -> Array[Vector2i]:
	var table = source.holder.table
	var map = table.slots_matrix
	var astar_grid:AStarGrid2D = table.astar_grid
	var start = source.slot.position
	var move_area = source.move_area
	var attack_area =source.attack_area

	var attack_points = find_attack_points(source)
	var paths = []
	var min_step = astar_grid.region.get_area()
	var startables:Array[Vector2i] = []
	if !attack_points.is_empty():
		for move_vector in move_area:
			var start_pos = start+move_vector
			if astar_grid.is_in_boundsv(start_pos) && standable(start_pos,source,map):
				startables.append(start_pos)
				for end_pos in attack_points:
					var current_path = astar_grid.get_id_path(start_pos, end_pos)
					if !current_path.is_empty():
						if min_step < current_path.size():
							continue
						if min_step > current_path.size():
							paths.clear()
						min_step = current_path.size()
						paths.append(current_path)
	if  !paths.is_empty():
		# 将所有路径按照起点y轴优先的顺序排序
		paths.sort_custom( func (a,b): return a[0].x > b[0].x if a[0].y == b[0].y else a[0].y > b[0].y )
		var parh:Array = paths[0]
		if !parh.is_empty():
			return parh.slice(0,min(source.mobility,parh.size()))

	return []

## 寻找可落位的所有有效攻击点位，如果没找到，则返回所有预演攻击点位
func find_attack_points(source: Card):
	var astar_grid:AStarGrid2D =  source.holder.table.astar_grid
	var map = source.holder.table.slots_matrix
	var attack_points:Dictionary = {} # 有效攻击点位集合
	var preview_points:Dictionary = {} # 预演攻击点位集合
	for target_slot in source.holder.table.slots: # 遍历地图 寻找攻击目标
		if is_enemy(target_slot.position,source,map): # 如果目标区域是敌方单位
			for attack_vector in source.attack_area: # 遍历攻击范围 寻找攻击点位
				# 目标所在位置-攻击向量 则可以确定一个攻击点位
				var attack_pos = target_slot.position-attack_vector
				if astar_grid.is_in_boundsv(attack_pos) && standable(attack_pos,source,map):# 如果该攻击点位有效
					if targetable(target_slot.position,source,map):# 如果目标可以被攻击
						attack_points[attack_pos] = 1 # 则记录该攻击点位 用字典的Key确保该点位的唯一性
					else:# 如果目标为不可攻击的敌方单位
						preview_points[attack_pos] = 1 # 则记录该预演攻击点位
	if attack_points.is_empty(): # 如果没找到有效的攻击点位，则返回预演攻击点位
		return preview_points
	return attack_points



func jump_to_target1(target: CardNode, pos: Vector2,
						   jump_height: float = 100.0,
						   duration: float = 0.6) -> Tween:
	var start_scale: Vector2 = target.scale
	var original_z_index: int = target.z_index  # 存储原始z_index

	var tween = target.create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

	# 水平移动
	tween.tween_property(target, "position", pos, duration)

	# 高度变化（核心修正）
	var height_func = func(time: float):
		var height_val = 4 * jump_height * (time - time * time)
		# 正确使用负值表示沉入背景
		target.z_index =   int(height_val) - original_z_index

	tween.tween_method(height_func, 0.0, 1.0, duration)

	# 缩放变化（俯视视角）
	var scale_func = func(time: float):
		var scale_factor = 1.0 - 0.3 * sin(PI * time)
		target.scale = start_scale * scale_factor

	tween.tween_method(scale_func, 0.0, 1.0, duration)

	# 旋转效果（可选）
	var rotate_func = func(time: float):
		target.rotation = 0.1 * sin(2 * PI * time)

	tween.tween_method(rotate_func, 0.0, 1.0, duration)

	# 动画完成时重置
	tween.chain().tween_callback(func():
		target.z_index = original_z_index  # 恢复原始z_index
		target.scale = start_scale
		target.rotation = 0.0
	)
	return tween

func move_animation(target:Control):
	return TweenUtil.move_to(target,0.5,Vector2.ZERO)
	#return jump_animation(target,Vector2.ZERO,100,0.6)

func jump_animation(
	control: Control,
	target_position: Vector2,
	jump_height: float = 100,
	duration: float = 0.6,
) -> Tween:
	# 获取场景树并创建并行补间
	var scene_tree := control.get_tree()
	var tween := scene_tree.create_tween().set_parallel(true)

	# 保存初始状态
	var start_position := control.position
	var start_scale := Vector2(control.scale)
	var start_z_index := control.z_index

	# 计算高度差（俯视角下y轴代表高度）
	var height_difference := target_position.y - start_position.y

	# 抛物线函数
	var parabolic := func(t: float) -> float:
		return 4.0 * t * (1.0 - t)  # 0->0, 0.5->1, 1->0

	# 主动画方法
	tween.tween_method(
		func(t: float):
		# 1. 水平位置移动（x轴方向）
		var current_x = lerp(start_position.x, target_position.x, t)

		# 2. 高度变化（y轴方向，俯视角的高度）
		var current_y = lerp(start_position.y, target_position.y, t)

		# 3. 跳跃高度（z轴方向，离地高度）
		var jump_z = parabolic.call(t) * jump_height

		# 4. 透视效果：离镜头越近（高度越高），缩放越大
		var scale_factor = 1.0 + jump_z * 0.002  # 缩放系数

		# 5. 梯形透视效果（基于高度差）
		var perspective_scale := Vector2.ONE
		if height_difference != 0:
			# 高度差越大，梯形效果越明显
			var perspective_factor := height_difference * 0.001
			# 当前节点朝向目标位置的比例
			var direction_factor := 1.0 if height_difference > 0 else -1.0
			# 应用梯形变形
			perspective_scale.x = 1.0 + perspective_factor * t * direction_factor
			perspective_scale.y = 1.0 - abs(perspective_factor) * t * 0.5

		# 组合所有变换
		control.position = Vector2(current_x, current_y)
		control.scale = start_scale * scale_factor * perspective_scale
		control.z_index = start_z_index + int(jump_z)  # 高度越高渲染层级越高

		, 0.0, 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 添加轻微旋转增强立体感（可选）
	var rotation_angle = deg_to_rad(3.0) * sign(height_difference)
	tween.tween_property(control, "rotation", rotation_angle, duration * 0.3)
	tween.tween_property(control, "rotation", 0.0, duration * 0.7).set_delay(duration * 0.3)

	# 动画结束时恢复原始z-index
	tween.finished.connect(func():
		control.z_index = start_z_index
		control.scale   = start_scale
	)

	return tween
