## An [InteractionComponent] allowing an object to be taken
## Currently not functional in any way.
class_name TakeableComponent extends InteractionComponent

signal object_taken

func _react_to_input():
	object_taken.emit()
