class_name MoveableComponent extends Node2D


@export var interactable_area: CollisionObject2D

var draggable = false
var is_being_dragged = false
var offset: Vector2

func _ready() -> void:
	if not interactable_area:
		push_warning(self.name, ": missing interactable area")
	else:
		interactable_area.mouse_entered.connect(_on_interaction_shape_2d_mouse_entered)
		interactable_area.mouse_exited.connect(_on_interaction_shape_2d_mouse_exited)

#func _on_takeable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_pressed("click"):
		#object_taken.emit()

func _process(delta: float) -> void:
	if Globals.current_mode == InteractionMode.MOVE:
		if draggable:
			if Input.is_action_just_pressed("click"):
				print("dragging")
				offset = get_global_mouse_position() - global_position
				is_being_dragged = true
				#object_clicked.emit(self)
		if is_being_dragged:
			get_parent().global_position = get_global_mouse_position() - offset
		if Input.is_action_just_released("click"):
			if is_being_dragged:
				is_being_dragged = false
	
func _on_interaction_shape_2d_mouse_entered() -> void:
	print("mouse entered")
	draggable = true

func _on_interaction_shape_2d_mouse_exited() -> void:
	draggable = false
	
