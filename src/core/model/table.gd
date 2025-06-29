class_name Table
extends Node

var TAG = "BattleProcess"

@export
var view: TableNode
@export
var slot_res: Script

var cards: Array[Card] = []
var slots: Array[Slot] = []
var width: int                 = 0
var height: int                = 0
var slots_matrix: Array[Array] = []
var slot_of_player: Dictionary = {}
var players: Array[Player]     = []
var astar_grid                 = AStarGrid2D.new()


func initialize(_width: int, _height: int, _players: Array[Player]):
	players = _players
	width = _width
	height = _height
	astar_grid.region = Rect2i(0, 0, width, height)
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN # 曼哈顿启发式算法
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN # 曼哈顿启发式算法
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER  # 禁止对角线移动
	#astar_grid.jumping_enabled = true # 启用或禁用跳跃，以跳过中间点并加快搜索算法的速度。  似乎并非是否可以越过障碍物


	var count: int                 =  width * height
	var half                       := height/2.0 * width
	slots = []
	slot_of_player = {}
	var player1_slots: Array[Slot] =  []
	var player2_slots: Array[Slot] =  []
	slot_of_player[players[0].player_id] = player1_slots
	slot_of_player[players[1].player_id] = player2_slots
	slots.resize(count)
	slots_matrix = []
	slots_matrix.resize(height)
	var i: int = 0
	for row in range(height):
		var rows: Array[Slot] = []
		slots_matrix[row] = rows
		rows.resize(width)
		for col in range(width):
			var slot: Slot = slot_res.new()
			var holder: Player
			if i<half:
				holder = players[0]
			else:
				holder = players[1]
			slot.initialize(holder, i, row, col)
			slot.content_changed.connect(slot_content_changed)
			slot_of_player[holder.player_id].append(slot)
			rows[col] = slot
			slots[i] = slot
			i+=1
	astar_grid.update()
	view.initialize(slots, width)
	lg.info("桌面初始化完成", {}, TAG)


func hand_to_table(card: Card, slot_index: int):
	cards.append(card)
	var anim_time = slots[slot_index].add_from_hand(card)
	await get_tree().create_timer(anim_time).timeout
	card.to_table()


func slot_content_changed(slot: Slot):
	var current_is_solid = slot.pass_able
	var is_solid         = astar_grid.is_point_solid(slot.position)
	if current_is_solid != is_solid:
		lg.info("槽位[%d,%d]当前%s可通过" % [slot.position.x, slot.position.y, "不" if is_solid else ""], {}, "Effect")
		astar_grid.set_point_solid(slot.position, current_is_solid)
		astar_grid.update()
