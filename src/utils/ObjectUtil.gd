## 基础对象工具类
class_name ObjectUtil

## 获取差异元素（差集）
## 在 [param array1] 中但不在 [param array2] 中的元素[br]
## [param fast]:是否使用高效算法，大型数组时推荐
static func find_array_difference(array1: Array, array2: Array,fast = false) -> Array:
	var diff = []
	if !fast:
		var dict = {}
		# 记录 array2 的元素
		for item in array2:
			dict[item] = true

		for item in array1:
			if not dict.has(item):
				diff.append(item)
	else:
		for item in array1:
			if item not in array2:
				diff.append(item)
	return diff

## 取两个数组的交集 并去重
static func get_unique_intersection(arr1: Array, arr2: Array) -> Array:
	if arr1 == null || arr2 == null || arr1.is_empty() || arr2.is_empty():
		return []
	var set1: Dictionary = {}
	var set2: Dictionary = {}
	# 将数组元素存入字典（去重）
	for element in arr1:
		set1[element] = true
	for element in arr2:
		set2[element] = true
	# 收集共同元素
	var intersection: Array[Variant] = []
	for element in set1:
		if element in set2:
			intersection.append(element)
	return intersection

## 超时定时器
static func timeout(node: Node, wait_time: float):
	await node.get_tree().create_timer(wait_time).timeout

## 超时后执行回调
static func timeout_call(node: Node, wait_time: float, callable: Callable):
	await node.get_tree().create_timer(wait_time).timeout
	callable.call()

## 超时后发送信号
static func timeout_signal(node: Node, wait_time: float, _signal: Signal):
	await node.get_tree().create_timer(wait_time).timeout
	_signal.emit()

## 对象转字典
static func obj_to_dict(obj: Variant)->Variant:
	if obj == null:
		return null
	if obj is Array:
		var arr=[]
		for item in obj:
			arr.append(obj_to_dict(item))
		return arr
	var dict: Dictionary = {}
	for prop in obj.get_property_list():
		if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var key   = prop["name"]
			var value = obj.get(key)
			# 递归处理嵌套 Object
			if value is Array or value is Object:
				value = obj_to_dict(value)
			if value != null:
				dict[key] = value
	return dict


static func dit_to_obj(data, target) -> Variant:
	#if data == null or target == null:
		#logs.e("数据源错误")
		#return null
	for key in data:
		var prop_value: Variant
		var prop_type: StringName = get_property_type(target, key)
		if data[key] == null:
			print("")
			#logs.e("["+key+"]填充数据为空")
		elif prop_type == "TYPE_BASE":
			prop_value = data[key]
		elif prop_type.begins_with("TYPE_ARRAY"):
			# 我不理解，为什么这里 target.get(key) 传递引用进去才可以
			# 而通过返回值进行 target.set(key, prop_value) 反而无效
			# 甚至 target.get(key) 本身为 null 都可以
			prop_value = dits_to_objs(data[key], target.get(key), prop_type)
		elif prop_type != null and !prop_type.is_empty():
			prop_value = dit_to_obj(data[key], instantiate_by_class_name(prop_type))
		else:
			#logs.e(str(target) +" 不存在属性：" +key)
			continue
		target.set(key, prop_value)
	return target


static func dits_to_objs(datas: Array, targets: Array[Variant], array_type:String) -> Variant:
	var array_data: Array[Variant] = []
	var class_type: String = array_type.split(" ")[1]
	array_data.resize(datas.size())
	targets.resize(datas.size())
	for i in range(datas.size()):
		if class_type == "TYPE_BASE":
			array_data[i] = datas[i]
		else:
			array_data[i] = dit_to_obj(datas[i], instantiate_by_class_name(class_type))
		targets[i] = array_data[i]
	return array_data


static func instantiate_by_class_name(_class_name: StringName) -> Object:
	# 内置类型（如 Node、Sprite2D）
	if ClassDB.can_instantiate(_class_name) and ClassDB.class_exists(_class_name):
		var _class = ClassDB.instantiate(_class_name)
		if _class != null:
			return _class
	# 自定义类（需提前用 class_name 声明）
	var path: String = "res://src/datas/"
	if ResourceLoader.exists(path+_class_name + ".gd"):
		return load(path+_class_name + ".gd").new()
	return null

## 获取属性类型
static func get_property_type(obj: Variant, name: String)->StringName:
	if obj == null:
		return ""
	var props = obj.get_property_list()
	for prop in props:
		if prop["name"] == name:
			var type = prop["type"]
			if type in [TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_BOOL]:
				return "TYPE_BASE"
			elif type == TYPE_ARRAY:
				var hint = prop["hint"]
				if hint == PROPERTY_HINT_ARRAY_TYPE:
					return "TYPE_ARRAY "+prop["hint_string"]
				else :
					return "TYPE_ARRAY TYPE_BASE"
			else:
				return prop["class_name"]
	return ""

static func get_script_name(obj:Variant) -> String:
	var script = obj.get_script()
	return script.resource_path.get_file().trim_suffix(".gd")


## 获取下标i在R*C矩阵中前后左右的下标
static func get_neighbor_indices(i: int, R: int, C: int,direction:String = "") -> Dictionary:
	var row: int = i / C
	var col: int = i % C
	var neighbor:Dictionary = {
		up = -1,
		down = -1,
		left = -1,
		right = -1,
	}
	if direction == "up" or !direction:    # 检查上方的索引
		neighbor["up"] = (row - 1) * C + col if row > 0 else -1
	if direction == "down" or !direction:  # 检查下方的索引
		neighbor["down"] = (row + 1) * C + col if row < R - 1 else -1
	if direction == "left" or !direction:  # 检查左侧的索引
		neighbor["left"] = row * C + (col - 1) if col > 0 else -1
	if direction == "right" or !direction: # 检查右侧的索引
		neighbor["right"] = row * C + (col + 1) if col < C - 1 else -1
	return neighbor

## 矩阵查询[br]
## 输入：二维数组map，索引index，过滤函数filter[br]
## 输出：最近符合条件的元素的坐标（Vector2i），无结果返回null
static func find_nearest_element(map: Array[Array], index: int, filter: Callable) -> Variant:
	# 1. 参数校验
	if map.is_empty() || index < 0 || index >= map.size() * map[0].size():
		return null

	# 2. 转换索引为二维坐标
	var cols: int = map[0].size()
	var row: int = index / cols
	var col: int = index % cols
	var item:Variant = map[row][col]

	# 3. 遍历二维数组并筛选
	var min_distance = INF
	var element = null
	for r in range(map.size()):
		for c in range(map[r].size()):
			# 跳过自身
			if r == row && c == col:
				continue
			# 调用过滤函数判断条件
			if filter.call(item, map[r][c]):
				# 计算曼哈顿距离
				var distance = abs(r - row) + abs(c - col)
				# 更新最近位置
				if distance < min_distance:
					min_distance = distance
					element = map[r][c]  # Godot中通常用(x,y)表示列行
	return element
