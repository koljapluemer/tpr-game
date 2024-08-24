class_name EventEndLevel extends Event


func _ready() -> void:
	if end_condition:
		push_warning("scene switch event is over instantly and should not have an end condition", name)
	super()
	
func _run():
	LevelManager.load_next_level()
	finish()
