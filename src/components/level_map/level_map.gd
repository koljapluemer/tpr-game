extends Node2D

const PLAYER_CAMERA_COMBO = preload("res://src/components/level_elements/player_camera_combo/player_camera_combo.tscn")

@export var parallax_background_scene: PackedScene
@export var arena_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# scenes with props
	var parallax_background = parallax_background_scene.instantiate()
	add_child(parallax_background)
	var arena = arena_scene.instantiate()
	add_child(arena)
	# always the same (for now, who knows)
	var player_and_camera = PLAYER_CAMERA_COMBO.instantiate()
	add_child(player_and_camera)
