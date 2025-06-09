## 上下文、成员动态读取
##
## @experimental: 该方法尚未完善。
class_name ProcessTaskReader
extends RefCounted

## 上下文读取模版配置
## 在模板文件配置示例:
## [codeblock]
## var config = { "member" = "@context{sth_target.member_a.0.x.$3}" }
## # 意味着
## self["member"] = context["sth_target"]["member_a"]["0"]["x"][3]
## [/codeblock]
var write_to_members: Dictionary[String, String] = {}

## 读取上下文配置并写入成员
func write_to_member(context: Dictionary):
	for member in write_to_members.keys():
		var key = write_to_members[member]
		var value = read(key, context, null)
		if value:
			self[member] = value

func read(key: String, context: Dictionary, target: Variant):
	if !key || key.is_empty():
		lg.warning("Key is Empty")
		return null
	if !key.ends_with("}"):
		lg.warning("Key is Error")
		return null
	var value
	var type
	if key.begins_with("@context{"):
		value = context
		type = "@context{"
	elif key.begins_with("@member{"):
		value = target
		type = "@member{"
	key = key.trim_prefix(type).trim_suffix("}")
	return read_one(value, key)

func read_one(target: Variant, key: String):
	if !target:
		return null
	var keys = key.split(".")
	var value = target
	for p in keys:
		var r = p
		if p.begins_with("$"):
			r = int(p.trim_prefix("$"))
		value = value[r]
	return value
