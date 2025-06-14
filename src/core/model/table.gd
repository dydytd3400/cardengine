class_name Table
extends Node

var TAG = "BattleProcess"

@export
var view:TableNode
@export
var slot_res:Script

var cards:Array[Card] = []
var slots:Array[Slot] = []

var width: int             = 0
var height: int               = 0
var slots_matrix: Array[Array] = []
var slot_of_player: Dictionary = {}

func initialize(_width:int,_height:int,players:Array[Player]):
	width = _width
	height = _height
	var count:int = width * height
	var half: int = height/2 * width
	slots=[]
	slots.resize(count)
	slots_matrix=[]
	slots_matrix.resize(height)
	var i: int = 0
	for row in range(height):
		var rows: Array[Slot] = []
		slots_matrix[row] = rows
		rows.resize(width)
		for col in range(width):
			var slot:Slot = slot_res.new()
			var holder
			if i<half:
				holder = players[0]
			else:
				holder = players[1]
			slot.initialize(i,holder)
			rows[col] = slot
			slots[i] = slot
			i+=1
	view.initialize(slots,width)
	lg.info("桌面初始化完成",{},TAG)

func hand_to_table(card:Card,slot_index:int):
	cards.append(card)
	slots[slot_index].hand_to_slot(card)
