## 埋葬效果
## 目标生物卡死亡后 将其放入墓堆
class_name EffectBury extends Effect


func execute(source: Player,_triggerer: Card,target, _params: Dictionary={}):
	var view = _triggerer.view
	var slot = _triggerer.slot
	lg.info("卡牌: %s 即将被移除！" % _triggerer.card_name, {}, "Effect")
	slot.remove_card(_triggerer,false)
	var at = source.plays.find(_triggerer)
	source.plays.remove_at(at)
	source.graveyard.append(_triggerer)
	await TweenUtil.scale_to(view,0.5,Vector2.ZERO)
	slot.view.remove_card(view)
	lg.info("卡牌: %s 已经被移除了！" % _triggerer.card_name, {}, "Effect",lg.LogLevel.DEBUG)
	effect_finish.emit()
