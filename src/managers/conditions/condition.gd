class_name Condition extends Node

var condition_fulfilled = false
signal fulfilled

func _fulfill():
	print("condition fulfilled")
	if not condition_fulfilled:
		condition_fulfilled = true
		fulfilled.emit()
