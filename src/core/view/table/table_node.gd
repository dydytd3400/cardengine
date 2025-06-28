@icon("res://assets/icons/table.svg")
class_name TableNode
extends Control

@export
var slot_background:PackedScene

func initialize(slots:Array[Slot],width:int):
	NodeUtil.clear_children($Grid)
	NodeUtil.clear_children($GridBackground)
	$Grid.columns = width
	$GridBackground.columns = width
	for slot in slots:
		$Grid.add_child(slot.view)
		$GridBackground.add_child(slot_background.instantiate())


func add_card(card:CardNode,slot:SlotNode):
	slot.add_card(card)
