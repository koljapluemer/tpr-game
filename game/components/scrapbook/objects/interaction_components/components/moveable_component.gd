class_name MoveableComponent extends InteractionComponent

var draggable = false
var is_being_dragged = false
var offset: Vector2

func _process(delta: float) -> void:
	pass
	#if Globals.current_mode == InteractionMode.MOVE:
		#if draggable:
			#if Input.is_action_just_pressed("click"):
				#print("dragging")
				#offset = get_global_mouse_position() - global_position
				#is_being_dragged = true
				##object_clicked.emit(self)
		#if is_being_dragged:
			#get_parent().global_position = get_global_mouse_position() - offset
		#if Input.is_action_just_released("click"):
			#if is_being_dragged:
				#is_being_dragged = false
	
func _on_interaction_shape_2d_mouse_entered() -> void:
	print("mouse entered")
	draggable = true

func _on_interaction_shape_2d_mouse_exited() -> void:
	draggable = false
	
