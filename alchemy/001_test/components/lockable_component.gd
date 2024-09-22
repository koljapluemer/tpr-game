class_name LockableComponent extends Node2D

signal object_lock_status_toggled

@export var selectable_area: CollisionObject2D

func _ready() -> void:
	if not selectable_area:
		push_warning(name, ": missing selectable area")
	else:
		selectable_area.input_event.connect(_on_selectable_area_input)

func _on_selectable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_lock_status_toggled.emit()
