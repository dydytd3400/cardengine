extends Node
class_name Slot

var view:SlotNode
var view_res:PackedScene = load("res://src/core/view/slot/slot_node.tscn")

## 卡槽持有者 初版暂时为固定某个玩家 后期可拓展地盘争夺
var holder:Player
var index:int
### 卡槽具体位置
#var position:Vector2 = Vector2.ZERO
## 占据该卡槽的卡牌 可为复数
var cards:Array[Card] = []

func initialize(_index:int,_holder: Player ):
	view = view_res.instantiate()
	index = _index
	holder = _holder


func hand_to_slot(card:Card):
	card.slot = self
	cards.append(card)
	view.hand_to_slot(card.view)

func slot_to_slot(card:Card):
	if !card.slot:
		lg.fatal("Card not in slot!")
		return
	card.slot.remove_card(card)
	card.slot = self
	cards.append(card)
	view.slot_to_slot(card.view)

func remove_card(card:Card):
	if !card:
		lg.fatal("Card is empty!")
		return
	var find = cards.find(card)
	if find<0:
		lg.fatal("Card not exist!")
		return
	cards.remove_at(find)
	view.remove_card(card.view)
