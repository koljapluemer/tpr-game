class_name AffordanceIsPushable extends Affordance

var is_moving := false
var mouse_offset_when_moved: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click_started)
	parent.click_was_released.connect(_on_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		parent.global_position.x = get_global_mouse_position().x + mouse_offset_when_moved.x


func _on_click_started() -> void:
	is_moving = true
	mouse_offset_when_moved = parent.global_position - get_global_mouse_position()
	MessageManager.object_drag_started.emit(parent)
	# delayed signal for the interaction, so that MOVE quests
	# only succeed after the object was dragged around a bit
	get_tree().create_timer(0.4).connect(
		"timeout", func():MessageManager.object_was_moved.emit(parent)
	)
	
func _on_click_released() -> void:
	is_moving = false
