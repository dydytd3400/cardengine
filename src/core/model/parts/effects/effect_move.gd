# 移动效果
class_name EffectMove extends Effect

@export
var flyable = false
func execute(source: Card,_triggerer,_target, _params: Dictionary={}):
	var slots = find_move_slot(source)
	move_to(source, slots)

## 寻找移动路径
func find_move_slot(source: Card) -> Array[Slot]:
	var map = source.holder.table.slots_matrix
	var start = source.slot.position
	var move_area = source.move_area
	var cover_area =source.attack_area
	var poss := find_accessible_positions(map,start,move_area,cover_area,passable.bind(source,map),standable.bind(source,map),targetable.bind(source,map))
	if poss && !poss.is_empty():
		# 按步数排序（步数少的在前）
		poss.sort_custom(func(a, b): return a["steps"].size() < b["steps"].size())
		var steps:Array = poss[0].steps
		if !steps || steps.is_empty():
			lg.warning("Undefine target")
			return []
		if source.mobility < steps.size():
			steps = steps.slice(0,source.mobility)
		var slots :Array[Slot]= []
		for step in steps:
			slots.append(map[step.y][step.x])
		return slots
	return []

## 移动到目标位置
func move_to(source: Card, slots: Array[Slot]):
	if slots && !slots.is_empty():
		for slot in slots:
			lg.info("卡牌: %s 即将从[%d,%d]移动到[%d,%d]" % [source.name,source.slot.position.x,source.slot.position.y,slot.position.x,slot.position.y])
			await slot.add_from_slot(source)
	else :
		lg.info("卡牌: %s 无可移动空间" % source.name,{},"",lg.LogLevel.FATAL)
		await CoreSystem.get_tree().process_frame

	effect_finish.emit()


## 目标位置是否可以通过
func passable(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return flyable || !target || target.pass_able

## 目标位置是否可以停留
func standable(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return !target || target.add_able

## 目标位置是否可以作为攻击对象
func targetable(pos:Vector2,_source:Card,map:Array[Array])->bool:
	var target:Slot = map[pos.y][pos.x]
	return target && target.target_able

## 查找所有满足条件的可达位置（按步数排序）
func find_accessible_positions(
	map: Array,                  # 二维网格地图
	start: Vector2i,             # 起始位置
	move_area: Array[Vector2i],  # 自定义移动方向向量
	cover_area: Array[Vector2i], # 目标检测区域向量
	_passable: Callable,    		 # 通行条件回调函数
	_standable:Callable,			 # 指定位置是否可停留
	_targetable:Callable          # 目标位置是否有效
) -> Array[Dictionary]:

	# 验证输入参数
	if not is_valid_map(map):
		lg.fatal("Invalid map")
		return []

	if not is_valid_position(start, map):
		lg.fatal("Start position out of bounds")
		return []

	if move_area.is_empty():
		lg.fatal("No move directions provided")
		return []

	if cover_area.is_empty():
		lg.fatal("No area vectors provided")
		return []

	# 获取所有从起点可达的位置（带步数信息）
	var reachable_data = find_reachable_positions(map, start, move_area, _passable)

	# 找出所有可达目标的位置（带步数信息）
	var accessible_positions: Array[Dictionary] = []

	for position in reachable_data.positions:
		var steps = reachable_data.steps[position]

		# 检查当前位置是否能覆盖到目标
		if covers_target(map, position, cover_area,_standable,_targetable):
			accessible_positions.append({
				"position": position,
				"steps": steps
			})
	return accessible_positions

## 使用BFS查找所有从起点可达的位置（返回位置列表和步数字典）
func find_reachable_positions(
	map: Array,
	start: Vector2i,
	move_area: Array[Vector2i],
	_passable: Callable
) -> Dictionary:

	var visited = {}
	var steps = {}  # 记录每个位置的路劲
	var queue = [{"pos": start, "steps": []}]
	visited[start] = true
	steps[start] = []

	while not queue.is_empty():
		var current = queue.pop_front()
		var current_pos = current["pos"]
		var current_steps = current["steps"]

		for dir in move_area:
			var neighbor = current_pos + dir
			# 创建路径副本并添加新位置
			var new_steps = current_steps.duplicate()
			new_steps.append(neighbor)

			# 检查邻居是否有效且未访问过
			if is_valid_position(neighbor, map) and not visited.get(neighbor, false):
				# 检查邻居是否可通行
				if _passable.call(neighbor):
					visited[neighbor] = true
					steps[neighbor] = new_steps
					queue.append({"pos": neighbor, "steps": new_steps})

	return {
		"positions": visited.keys(),
		"steps": steps
	}

## 检查当前位置是否能覆盖到目标
func covers_target(
	map: Array,
	position: Vector2i,
	cover_area: Array[Vector2i],
	_standable:Callable,
	_targetable:Callable
) -> bool:
	# 检查目标位置是否可停留
	if !_standable.call(position):
		return false
	for vector in cover_area:
		var target_pos = position + vector

		# 检查目标位置是否在地图范围内
		if not is_valid_position(target_pos, map):
			continue

		# 检查目标位置是否非空（即包含目标）
		if _targetable.call(target_pos):
			return true

	return false

## 检查地图是否有效
func is_valid_map(map: Array) -> bool:
	if map.size() == 0:
		return false

	var width = map[0].size()
	for row in map:
		if row.size() != width:
			return false

	return true

## 检查位置是否在地图范围内
func is_valid_position(pos: Vector2i, map: Array) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.y < map.size() and pos.x < map[0].size()
