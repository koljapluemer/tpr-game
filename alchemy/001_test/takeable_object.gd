class_name TakeableObject extends Resource

@export var instantiation:PackedScene
@export var key: String
@export var responds_to: Array[InteractionMode]

#
#func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_pressed("click"):
		#object_destroyed.emit(self)
		#queue_free()
