extends Node
class_name Slot

var view:SlotNode

## 卡槽持有者 初版暂时为固定某个玩家 后期可拓展地盘争夺
var holder:Player
## 卡槽具体位置
var position:Vector2 = Vector2.ZERO
## 占据该卡槽的卡牌 可为复数
var cards:Array[Card] = []
