extends Object
class_name Slot

## 卡槽持有者 初版暂时为固定某个玩家 后期可拓展地盘争夺
var owner:Player
## 卡牌具体位置
var position:Vector2 = Vector2.ZERO
var cards:Array[Card] = []