extends Affordance

var is_moving := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.click_was_started.connect(_on_click_started)
	parent.click_was_released.connect(_on_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		parent.global_position.x = get_global_mouse_position().x + mouse_offset_when_moved.x


func _on_click_started() -> void:
	is_moving = true
	
func _on_click_released() -> void:
	is_moving = false
