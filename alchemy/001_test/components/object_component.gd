class_name ObjectComponent extends Node2D

@export var selectable_area: CollisionObject2D
@export var word: Word

func _ready() -> void:
	if not selectable_area:
		push_warning(name, ": missing selectable area")
	else:
		selectable_area.input_event.connect(_on_selectable_area_input)

# to overwrite by children
func _on_selectable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

static func get_mode_name():
	return "ACTION"
