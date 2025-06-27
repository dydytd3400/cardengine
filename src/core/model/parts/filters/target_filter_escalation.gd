## 递进过滤器
class_name TargetFilterEscalation extends TargetFilter

@export
var filters:Array[TargetFilter] = []

func _filter(source):
	if filters.is_empty():
		return source
	for i in range(filters.size()): # 逐级过滤
		var target = filters[i].filter(source)
		if !target:
				return null
		if target is Array && target.is_empty(): # 如果当前源是数组
			return null
		if i == filters.size()-1:# 如果是最后一级，则返回过滤目标
			return target
		source = target
	return null
