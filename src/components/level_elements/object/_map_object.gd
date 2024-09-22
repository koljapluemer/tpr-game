class_name MapObject extends Node2D

signal body_entered

@export var show_outline = true
@export var key:String = ""


@onready var sprite: Sprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape2D
const MATERIAL_OUTLINE = preload("res://src/shared/material_outline.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.material = MATERIAL_OUTLINE
	
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print("body entered me (", name, "): ", body.name)
	body_entered.emit(body)
