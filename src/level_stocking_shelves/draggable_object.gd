extends Node2D

var draggable = false
var is_being_dragged = false
var offset: Vector2

@onready var interaction_shape: Area2D = %InteractionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			is_being_dragged = true
	if is_being_dragged:
		global_position = get_global_mouse_position() - offset
	if Input.is_action_just_released("click"):
		is_being_dragged = false
			


func _on_interaction_shape_2d_mouse_entered() -> void:
	draggable = true
	scale = Vector2(1.2, 1.2)


func _on_interaction_shape_2d_mouse_exited() -> void:
	draggable = false
	scale = Vector2(1, 1)
	
