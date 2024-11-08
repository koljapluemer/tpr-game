class_name AffordanceIsOpenable extends AffordanceActive

var click_in_action := false

# this is an array in answer to godot stupid problem
# with cIrCuLaR rEfEreNcEs
@export var scene_path_to_load_on_open := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click)
	parent.click_was_released.connect(_on_click_released)


func _on_click() -> void:
	if not click_in_action:
		click_in_action = true
		_report_action(parent, null)
		if scene_path_to_load_on_open:
			var spawn_point := parent.parent_spawn_point
			MessageManager.object_disappeared.emit(parent)
			parent.queue_free()
			spawn_point.change_scene_to_path(scene_path_to_load_on_open)


# apparently can't use "just pressed" so here we go	
func _on_click_released() -> void:
	if click_in_action:
		click_in_action = false
	

func get_verb_key() -> String:
	return "OPEN"
