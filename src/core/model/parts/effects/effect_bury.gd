## 埋葬效果
## 目标生物卡死亡后 将其放入墓堆
class_name EffectBury extends Effect


func execute(source: Player,_triggerer: Card,target, _params: Dictionary={}):
	var slot = _triggerer.slot
	slot.remove_card(_triggerer,false)
	var at = source.plays.find(_triggerer)
	source.plays.remove_at(at)
	source.graveyard.append(_triggerer)
	await TweenUtil.size_to(_triggerer.view,0.5,Vector2.ZERO)
	slot.view.remove_card(_triggerer.view)
	effect_finish.emit()
