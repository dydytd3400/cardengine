## 流程任务匹配路由
##
## 当[ProcessTask]退出后，会通过[method _find_next]去路由到下一个[ProcessTask][br]
## 可通过[ProcessTemplate]自定义配置包括[ProcessTaskBatch]的所有[ProcessTask]的[ProcessTaskRouter][br]
## 只允许在同级流程任务之间进行路由[br]
## @experimental: 该方法尚未完善。
class_name ProcessTaskRouterMatch
extends ProcessTaskRouter

var matchers: Array[Variant] = []


## 返回下一个同级流程任务
func _find_next(_current_task: ProcessTask, _completed: bool, _msg: Dictionary = {}) -> ProcessTask:
	for cfg in matchers:
		var matcher = cfg.matcher
		var matcher_value
		if matcher.begins_with("await "):
			matcher = matcher.trim_prefix("await ")
			matcher_value = await await_parse_expression(matcher, _msg)
		else:
			matcher_value = parse_expression(matcher, _msg, true)

		if _eq(error_id, matcher_value):
			continue
		for key in cfg:
			if key != "matcher":
				if _eq(cfg[key], matcher_value):
					return _current_task.get_parent_task(key)
	return null
