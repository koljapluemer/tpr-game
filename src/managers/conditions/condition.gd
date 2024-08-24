class_name Condition extends Node

signal fulfilled

var condition_fulfilled = false

@export var delay_signal_by = 0


func _fulfill():
	print("condition fulfilled")
	if not condition_fulfilled:
		condition_fulfilled = true
		get_tree().create_timer(delay_signal_by).connect("timeout", _actually_fulfill)

func _actually_fulfill():
		fulfilled.emit()
