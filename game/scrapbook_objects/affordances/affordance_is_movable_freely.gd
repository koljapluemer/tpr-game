class_name AffordanceIsMovableFreely extends Affordance

var is_moving := false
var mouse_offset_when_moved: Vector2


func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click_started)
	parent.click_was_released.connect(_on_click_released)
	is_usable_in_a_quest = true

func _on_click_started() -> void:
	is_moving = true
	mouse_offset_when_moved = parent.global_position - get_global_mouse_position()
	# delayed signal for the interaction, so that MOVE quests
	# only succeed after the object was dragged around a bit
	get_tree().create_timer(0.4).connect(
		"timeout", _report_affordance_based_interaction
	)

func _on_click_released() -> void:
	if is_moving:
		is_moving = false
		var areas: Array[Area2D]= parent.get_overlapping_areas()
		_do_interactions_with_objects_I_was_dropped_on(areas)
				
			
func _process(delta: float) -> void:
	if is_moving:
		parent.global_position = get_global_mouse_position() + mouse_offset_when_moved
	
func get_key() -> String:
	return "MOVE"
