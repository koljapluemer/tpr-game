@tool
class_name MapObjectInteractable extends MapObject

signal was_interacted_with

@export var is_interactable = true
@export var hide_after_interaction = false

var player_within_interaction_range = false


@onready var player = get_tree().get_first_node_in_group("player")
@onready var interaction_shape: Area2D = %InteractionShape2D
@onready var interaction_collision_shape_2d: CollisionShape2D = %InteractionCollisionShape2D

const MATERIAL_OUTLINE_SELECTABLE = preload("res://src/shared/material_outline_selectable.tres")

func _ready():
	if not is_interactable:
		interaction_shape.queue_free()
	super()


func _on_interaction_shape_2d_body_entered(body: Node2D) -> void:
	if body == player:
		# TODO: this change is invisible
		player_within_interaction_range = true
		pass

func _on_interaction_shape_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_within_interaction_range = false
		
# watch out: this uses collision shape, not interaction shape
func _on_area_2d_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if player_within_interaction_range:
			# TODO: is this a bad idea; should this be a signal?
			# on the other hand it's basically mouse-click based...
			player.interact_with_object(self)
			was_interacted_with.emit(player)
			
			if hide_after_interaction:
				hide()
