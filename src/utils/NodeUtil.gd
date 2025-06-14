## 节点工具类
class_name NodeUtil

## 移除[param node]的所有子节点
static func clear_children(node: Node) -> Array[Node]:
	var children: Array[Node] = node.get_children()
	for child in children:
		node.remove_child(child)
	return children

## 将[param node]从父节点移除
static func remove_from_parent(node: Node) -> void:
	if node and node.get_parent():
		node.get_parent().remove_child(node)

## 将全局坐标[param global_pos]转换为[param target]节点的本地坐标
static func to_local(target,global_pos:Vector2) -> Vector2:
	if target is Node2D:
		return target.to_local(global_pos)
	elif target is Control:
		return target.get_global_transform().affine_inverse() * global_pos
	return global_pos

## 将[param child]的全局坐标相对于[param parent]对应的本地坐标的方式添加进[param parent]
static func add_by_local(parent,child) -> void:
	var global_pos: Vector2 = child.global_position
	var local_pos: Vector2  = to_local(parent,global_pos)
	remove_from_parent(child)
	parent.add_child(child)
	child.position = local_pos

## 获取[param child]的全局坐标相对于[param parent]对应的本地坐标
static func get_by_local(parent,child) -> Vector2:
	return to_local(parent,child.global_position)
