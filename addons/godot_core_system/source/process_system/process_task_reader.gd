## 上下文、成员动态读取或执行表达式
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
var error_id = UUID.generate()
## 读取上下文配置并写入成员
func write_to_member(context: Dictionary):
	for member in write_to_members.keys():
		var key = write_to_members[member]
		var value = read(key, context, null)
		if value:
			self[member] = value

func read(key: String, context: Dictionary, target: Variant):
	if !key || key.is_empty():
		lg.warning("Key is empty")
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

## 解析表达式
func parse_expression(_expr: String, context: Dictionary,need_result : bool):
	var result = _parse_expression(_expr,context)
	return evaluate_expression(result[0], result[1], result[2],need_result)

## 执行表达式
func evaluate_expression(expression: String, variable_names, variable_values,need_result : bool) -> Variant:
	var expr := Expression.new()
	# 尝试解析表达式（不包含任何变量）
	var error = expr.parse(expression, variable_names)
	if error != OK:
		lg.fatal("解析表达式失败: " + expr.get_error_text())
		return error_id

	var result = null
	# 执行表达式（允许常量表达式）
	if need_result:
		result = expr.execute(variable_values,self)
	else:
		expr.execute(variable_values,self)
	if expr.has_execute_failed():
		lg.warning("执行表达式失败: " + expr.get_error_text())
		return error_id
	return result

## 同步解析表达式
func await_parse_expression(_expr: String, context: Dictionary):
	var result = _parse_expression(_expr,context)
	return await await_evaluate_expression(result[0], result[1], result[2])

## 同步执行表达式
func await_evaluate_expression(expression: String, variable_names, variable_values) -> Variant:
	var expr := Expression.new()
	# 尝试解析表达式（不包含任何变量）
	var error = expr.parse(expression, variable_names)
	if error != OK:
		lg.fatal("解析表达式失败: " + expr.get_error_text())
		return error_id

	# 执行表达式（允许常量表达式）
	var result = await expr.execute(variable_values,self)
	if expr.has_execute_failed():
		lg.warning("执行表达式失败: " + expr.get_error_text())
		expr.unreference()
		return error_id
	return result

func _parse_expression(_expr: String, context: Dictionary):
	var _placeholder_regex: RegEx
	_placeholder_regex = RegEx.new()
	_placeholder_regex.compile(r"@(context|member)\{(.*?)\}")
	var variable_names = []
	var variable_values = []
	var match_expr = _expr
	for match_result in _placeholder_regex.search_all(_expr):
		var variable_formater = match_result.get_string(0)
		var variable_type = match_result.get_string(1)
		var variable_name = match_result.get_string(2)
		match_expr = match_expr.replace(variable_formater, variable_name)
		if !variable_names.has(variable_name):
			var variable_value
			if variable_type == "context":
				variable_value = read_one(context, variable_name)
			elif variable_type == "member":
				variable_value = read_one(self, variable_name)
			variable_names.append(variable_name)
			variable_values.append(variable_value)
	return [match_expr, variable_names, variable_values]

func _eq(a,b)->bool:
	if !a && !b:
		return true
	if typeof(a) == typeof(b):
		return a == b
	return false
