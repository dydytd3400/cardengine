## 效果执行类
class_name Effect extends Resource

signal effect_finish
const TAG="Effect"

## 使效果生效
## [param _source] 效果来源,通常代表哪个目标执行了该效果
## [param _triggerer] 触发执行该效果的触发者,参考因素，与效果本身无关，由效果自身确定用法，可能为空
## [param _target] 绑定该效果所筛选出来的目标,参考因素，与效果本身无关，由效果自身确定用法，可能为空
## [param params] 不定参数,由执行者决定内容
func execute(_source,_triggerer,_target, _params: Dictionary={}):
	effect_finish.emit()
