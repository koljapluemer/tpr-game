## An [InteractionComponent] allowing an object to be taken
## Currently not functional in any way.
class_name TakeableComponent extends InteractionComponent

signal object_taken

func _on_takeable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_taken.emit()

static func get_mode_name():
	return "TAKE"
