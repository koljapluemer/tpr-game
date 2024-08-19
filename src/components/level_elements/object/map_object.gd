@tool
class_name MapObject extends Node2D

@export var item: Item

const MAP_OBJECT_SPRITE = preload("res://src/components/level_elements/object/map_object_sprite.tscn")
const MAP_OBJECT_COLLISION = preload("res://src/components/level_elements/object/map_object_collision.tscn")


func _ready() -> void:
	if item:
		var sprite_2d = MAP_OBJECT_SPRITE.instantiate()
		add_child(sprite_2d)
		# size and position
		sprite_2d.texture = item.sprite
		sprite_2d.scale = Vector2(item.resize_factor, item.resize_factor)
		sprite_2d.position = item.offset
		# collision shape
		var collision_shape = MAP_OBJECT_COLLISION.instantiate()
		add_child(collision_shape)
		collision_shape.get_node("%CollisionShape2D").shape.radius = item.collision_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_object():
	show()
