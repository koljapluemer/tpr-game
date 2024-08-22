@tool
class_name MapObjectInteractable extends MapObject


@onready var player = get_tree().get_first_node_in_group("player")
var player_within_interaction_range = false
@onready var interaction_shape: Area2D = %InteractionShape2D
@onready var interaction_collision_shape_2d: CollisionShape2D = %InteractionCollisionShape2D
@onready var sprite_selectable: Sprite2D = %SpriteSelectable

const MATERIAL_OUTLINE_SELECTABLE = preload("res://src/shared/material_outline_selectable.tres")
const MATERIAL_OUTLINE = preload("res://src/shared/material_outline.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item:
		interaction_collision_shape_2d.shape.radius = item.interaction_radius
	super()


func _on_interaction_shape_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player_within_interaction_range = true
		$Sprite.material = MATERIAL_OUTLINE_SELECTABLE


func _on_interaction_shape_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_within_interaction_range = false
		$Sprite.material = MATERIAL_OUTLINE
		
# watch out: this uses collision shape, not interaction shape
func _on_area_2d_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if player_within_interaction_range:
			print(name, ": I got interacted with")
