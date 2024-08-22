@tool
class_name MapObject extends Node2D

signal body_entered

@export var item:Item

@onready var sprite: Sprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item:
		sprite.texture = item.sprite
		sprite.scale = Vector2(item.resize_factor, item.resize_factor)
		sprite.position = item.offset
		# TODO: why doesn't this work with the item collision radius??
		#collision_shape.shape.radius = item.collision_radius
		collision_shape.shape.radius = 20
		print(name, ": set item radius etc")
	print(name, ": changed props")

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print("body entered me (", name, "): ", body.name)
	body_entered.emit(body)
