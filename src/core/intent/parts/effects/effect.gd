## 效果执行类
class_name Effect
extends Object

## 使效果生效
## [param source] 效果来源,通常代表哪个目标执行了该效果
## [param params] 不定参数,由执行者决定内容，通常至少会携带一个target
func execute(_source: Card, _params: Dictionary={}):
	pass
