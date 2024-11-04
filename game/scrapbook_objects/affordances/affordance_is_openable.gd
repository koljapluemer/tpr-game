class_name AffordanceIsOpenable extends Affordance

@export var is_open := false

@export var texture_when_open: CompressedTexture2D
@export var texture_when_closed: CompressedTexture2D

var click_in_action := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click)
	parent.click_was_released.connect(_on_click_released)
	is_usable_in_a_quest = true
	#adapt_texture()

func adapt_texture() -> void:
	if is_open:
		if texture_when_open:
			Logger.log(1, "changing texture to open", ["LOCK"])
			parent.sprite_2d.texture = texture_when_open
	else:
		if texture_when_closed:
			Logger.log(1, "changing texture to closed", ["LOCK"])
			parent.sprite_2d.texture = texture_when_closed

func _on_click() -> void:
	if not click_in_action:
		click_in_action = true
		Logger.log(1, "lock/unlock click registered", ["LOCK"])
		is_open = !is_open 
		get_tree().create_timer(0.2).connect(
			"timeout", _report_affordance_based_interaction
		)
		adapt_texture()

# apparently can't use "just pressed" so here we go	
func _on_click_released() -> void:
	if click_in_action:
		click_in_action = false
	

func get_key() -> String:
	if is_open:
		return "CLOSE"
	else: 
		return "OPEN"
