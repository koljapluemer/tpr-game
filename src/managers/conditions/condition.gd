class_name Condition extends Node

var condition_fulfilled = false
signal fulfilled

func _fulfill():
	if not condition_fulfilled:
		condition_fulfilled = true
		fulfilled.emit()
