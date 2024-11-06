class_name AffordanceIsCloseable extends AffordanceActive

var click_in_action := false
@export var scene_to_load_in_on_close: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click)
	parent.click_was_released.connect(_on_click_released)


func _on_click() -> void:
	if not click_in_action:
		click_in_action = true
		_report_action(parent, null)
		if scene_to_load_in_on_close:
			print("loading close scene")
			var spawn_point := parent.parent_spawn_point
			MessageManager.object_disappeared.emit(parent)
			parent.queue_free()
			spawn_point.change_scene(scene_to_load_in_on_close)


# apparently can't use "just pressed" so here we go	
func _on_click_released() -> void:
	if click_in_action:
		click_in_action = false
	

func get_verb_key() -> String:
	return "CLOSE"
