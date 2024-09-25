## An [InteractionComponent] allowing an object to be touched
## Basically every object should have this
class_name TouchableComponent extends InteractionComponent


func _react_to_input() -> bool:
	# should this be implemented by the parent
	# and we just call shake?
	var tween = create_tween()
	tween.tween_property(owner, "rotation", .1, .02)
	tween.tween_property(owner, "rotation", -.1, .02)
	tween.tween_property(owner, "rotation", 0, .02)
	return true
