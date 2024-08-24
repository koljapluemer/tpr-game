class_name EventGoToScene extends Event

@export var scene: PackedScene

func _ready() -> void:
	if end_condition:
		push_warning("scene switch event is over instantly and should not have an end condition", name)
	if not scene:
		push_warning(name, ": scene not set")
	super()
	
func _run():
	get_tree().change_scene_to_packed(scene)
	finish()
