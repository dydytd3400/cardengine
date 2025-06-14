class_name PropertyUtil

# 节点及其子节点的透明度
static func alpha(target,_alpha:float)->void:
	target.modulate.a = _alpha

# 节点的透明度，不会影响子节点
static func alpha_self(target,_alpha:float)->void:
	target.self_modulate.a = _alpha
