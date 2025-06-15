@icon("res://assets/icons/table.svg")
class_name TableNode
extends Control

func initialize(slots:Array[Slot],width:int):
	NodeUtil.clear_children($Grid)
	$Grid.columns = width
	for slot in slots:
		$Grid.add_child(slot.view)


func add_card(card:CardNode,slot:SlotNode):
	slot.add_card(card)
