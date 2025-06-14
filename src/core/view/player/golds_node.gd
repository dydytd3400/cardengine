@icon("res://assets/icons/golds.svg")
class_name GoldsNode
extends Node2D


var gold:int :
	set(value):
		var v:int = value / 2
		for i in range(1,6):
			var node = str(i)
			get_node(node).visible = i<=v
