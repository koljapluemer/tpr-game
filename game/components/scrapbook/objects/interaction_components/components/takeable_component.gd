## An [InteractionComponent] allowing an object to be taken
## Currently not functional in any way.
class_name TakeableComponent extends InteractionComponent

func _react_to_input() -> bool:
	owner.queue_free()
	return true
	
