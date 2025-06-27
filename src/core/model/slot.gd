extends Node
class_name Slot

var view:SlotNode
var view_res:PackedScene = load("res://src/core/view/slot/slot_node.tscn")

## 卡槽持有者 初版暂时为固定某个玩家 后期可拓展地盘争夺
var holder:Player
## 占领着 当前卡槽所占位卡牌的拥有者 可能为空 通常不会改变holder<暂定>
var occupier:Player:
	get():
		if cards.is_empty():
			return null
		for i in range(cards.size() - 1, -1, -1):
			var card = cards[i]
			if card.exclusive:
				return card.holder
		return null

var index:int
### 卡槽具体位置
var position:Vector2i = Vector2i.ZERO
## 占据该卡槽的卡牌 可为复数
var cards:Array[Card] = []
## 当前卡槽是否可以添加卡牌
var add_able:bool = true:
	get():return add_able && (cards.is_empty() || cards.filter(func (card:Card):return card.exclusive).is_empty()) # 卡槽为空 或者没有独占状态的卡
var pass_able:bool = true:
	get():return add_able && pass_able
var target_able:bool = true:
	get():return !cards.is_empty() && cards[-1].target_able

## 初始化卡槽
func initialize(_holder: Player,_index:int,y:int,x:int ):
	view = view_res.instantiate()
	index = _index
	holder = _holder
	position.x = x
	position.y = y

## 从手牌添加至卡槽
func add_from_hand(card:Card):
	if !add_able:
		_error("Cannot Add！",card)
		return
	card.slot = self
	cards.append(card)
	view.add_from_hand(card.view)

## 从卡槽添加至卡槽
func add_from_slot(card:Card):
	if !add_able:
		_error("Cannot Add！",card)
		return
	if !card.slot:
		_error("Card not in slot!",card)
		return
	card.slot.remove_card(card,false)
	card.slot = self
	cards.append(card)
	await view.add_from_slot(card.view)

## 移除卡牌
func remove_card(card:Card,remove_from_view:bool = true):
	if !card:
		_error("Card is empty!")
		return
	var find = cards.find(card)
	if find<0:
		_error("Card not exist!",card)
		return
	cards.remove_at(find)
	if remove_from_view:
		view.remove_card(card.view)

func _error(msg:String,target:Card = null):
	var target_str = ""
	if target:
		target_str = "| by: %s" % target.card_name
	lg.fatal("[Slot] %s ==> at: %d%s" % [msg,index,target_str])
