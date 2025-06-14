## 表达式流程任务执行模块[br]
##
## 通过表达式配置执行模块，详情参见示例代码：
## [codeblock]{
## 				"key" = "流程key",
## 				"executor" = {
## 					"resource" = "res://addons/godot_core_system/source/process_system/process_task_executor_expression.gd",
## 					"expressions" = [{
## 						"expression" = "await @context{battle_field}.initialize()", # 如果表达式配置了await关键字，则会等待异步操作完成，否则同步调用执行
##						# 如果如下配置中存在对调用方法有返回值要求，且未配置await关键字，则会抛出异常。该特性与GDScript一致
##						# 简而言之，通过表达式调用异步方法，要么如示例中一样配置await关键字，要么不要取返回值
## 						"append" = "result", # 始终将返回值追加至上下文"result"
## 						"complete" = 13, # 返回值为 13 执行executor.complete
## 						"complete_append" = "result", # complete时将返回值追加至上下文"result"
## 						"cancel" = "sth result", # 返回值为 "sth result" 执行executor.cancel
## 						"cancel_append" = "result", # cancel时将返回值追加至上下文"result"
## 						"finally" = "complete" # 不取返回值 结束后执行 executor.complete
## 						"finally" = "cancel" # 不取返回值 结束后执行 executor.cancel
## 						"finally_append" = "result", # 无论是何返回值 都会将返回值追加至上下文"result"
## 					}]
## 				}[/codeblock]
## @experimental: 该方法尚未完善。
class_name ProcessTaskExecutorExpression
extends ProcessTaskExecutor


var expressions = []

func _execute(task: ProcessTask, _msg: Dictionary = {}):
	#print("当前栈深[_execute]=================================>>>>  "+str(get_stack().size()))
	for expr_cfg in expressions:
		var expr:String = expr_cfg.expression

		var is_need_result = false
		# 以下任一条件满足 即代表需要取得表达式返回值
		if expr_cfg.has("append"): # 将执行结果追加至上下文
			is_need_result = true
		elif expr_cfg.has("complete"): # 表达式执行结果符合complate走向
			is_need_result = true
		elif expr_cfg.has("cancel"): # 表达式执行结果符合cancel走向
			is_need_result = true
		elif expr_cfg.has("finally") && expr_cfg.has("finally_append"): # 若指定了finally
			is_need_result = true

		var expr_value = null
		if expr.begins_with("await "):# 如果手动指定了同步执行，则无论是否取返回值，都要进行同步执行
			expr = expr.trim_prefix("await ")
			expr_value = await await_parse_expression(expr, _msg)
		else:
			if is_need_result:
				expr_value = parse_expression(expr, _msg,is_need_result)
			else:
				parse_expression(expr, _msg,is_need_result)

		if _eq(error_id,expr_value):
			continue

		if expr_cfg.has("append"): # 将执行结果追加至上下文
			_msg[expr_cfg["append"]] = expr_value
		var is_complete = false
		if expr_cfg.has("complete") && _eq(expr_cfg["complete"],expr_value): # 表达式执行结果符合complate走向
			if expr_cfg.has("complete_append"): # 将执行结果追加至上下文
				_msg[expr_cfg["complete_append"]] = expr_value
			is_complete = true
		elif expr_cfg.has("cancel") && _eq(expr_cfg["cancel"],expr_value): # 表达式执行结果符合cancel走向
			if expr_cfg.has("cancel_append"): # 将执行结果追加至上下文
				_msg[expr_cfg["cancel_append"]] = expr_value
			is_complete = false
		elif expr_cfg.has("finally"): # 若指定了finally
			if expr_cfg.has("finally_append"): # 将执行结果追加至上下文
				_msg[expr_cfg["finally_append"]] = expr_value
			var finally = expr_cfg["finally"]
			is_complete = finally == "complete" # 且finally为complete或cancel，则始终都会根据指定走向执行
			if !is_complete && finally != "cancel":
				continue # 否则该执行模块挂起
		else : # 若以上皆未指定 则该执行模块挂起
			continue
		if is_complete:
			completed(task,_msg)
		else :
			cancel(task,_msg)
