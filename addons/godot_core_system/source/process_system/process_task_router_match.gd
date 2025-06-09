## 流程任务匹配路由
##
## 当[ProcessTask]退出后，会通过[method _find_next]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 只允许在同级流程任务之间进行路由[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouterMatch
extends ProcessTaskRouter

var matchers = []
var error_id = UUID.generate()

## 返回下一个同级流程任务
func _find_next(_current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	for cfg in matchers:
		var matcher = cfg.matcher
		var matcher_value = parse_matcher(matcher, _msg)
		if _eq(error_id,matcher_value):
			continue
		for key in cfg:
			if key != "matcher":
				if _eq(cfg[key],matcher_value):
					return _current_task.get_parent_task(key)
	return null

func _eq(a,b)->bool:
	if !a && !b:
		return true
	if typeof(a) == typeof(b):
		return a == b
	return false

## 解析匹配表达式
func parse_matcher(matcher: String, context: Dictionary):
	var _placeholder_regex: RegEx
	_placeholder_regex = RegEx.new()
	_placeholder_regex.compile(r"@(context|member)\{(.*?)\}")
	var variable_names = []
	var variable_values = []
	var match_expr = matcher
	for match_result in _placeholder_regex.search_all(matcher):
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

	return evaluate_expression(match_expr, variable_names, variable_values)

## 执行表达式
func evaluate_expression(expression: String, variable_names, variable_values) -> Variant:
	var expr := Expression.new()

	# 尝试解析表达式（不包含任何变量）
	var error = expr.parse(expression, variable_names)
	if error != OK:
		lg.fatal("解析表达式失败: " + expr.get_error_text())
		return error_id

	# 执行表达式（允许常量表达式）
	var result = expr.execute(variable_values)
	if expr.has_execute_failed():
		lg.warning("执行表达式失败: " + expr.get_error_text())
		return error_id

	return result
