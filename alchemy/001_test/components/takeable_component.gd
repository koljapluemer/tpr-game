class_name TakeableComponent extends Node2D

signal object_taken

@export var takeable_area: CollisionObject2D

func _ready() -> void:
	if not takeable_area:
		push_warning(self, ": missing takeable area")
	else:
		takeable_area.input_event.connect(_on_takeable_area_input)

func _on_takeable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_taken.emit()
