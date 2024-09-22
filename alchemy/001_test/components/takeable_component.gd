class_name TakeableComponent extends ObjectComponent

signal object_taken

func _on_takeable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_taken.emit()

static func get_mode_name():
	return "TAKE"
