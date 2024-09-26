## An [InteractionComponent] allowing an object to be moved
class_name MoveableComponent extends InteractionComponent

signal movement_stopped

var draggable = false
var is_being_dragged = false
var offset: Vector2


func _react_to_input():
	if not is_being_dragged:
		is_being_dragged = true

func _process(delta: float) -> void:
	if is_being_dragged:
		owner.global_position = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			is_being_dragged = false
			movement_stopped.emit()
