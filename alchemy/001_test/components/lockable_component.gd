class_name LockableComponent extends ObjectComponent

signal object_lock_status_toggled


func _on_selectable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_lock_status_toggled.emit()

static func get_mode_name():
	return "LOCK"
