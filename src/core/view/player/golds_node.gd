@icon("res://assets/icons/golds.svg")
class_name GoldsNode
extends Node2D

var gold: int:
	set(value):
		var v = value / 2.0
		for i in range(1, 6):
			var node: String = str(i)
			get_node(node).visible = i<=v
