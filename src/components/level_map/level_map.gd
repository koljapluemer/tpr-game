@tool
extends Node2D

const PLAYER_CAMERA_COMBO = preload("res://src/components/level_elements/player_camera_combo/player_camera_combo.tscn")
const TUTOR = preload("res://src/components/level_elements/tutor/tutor.tscn")

@export var parallax_background_scene: PackedScene
@export var arena_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# scenes with props
	if parallax_background_scene:
		var parallax_background = parallax_background_scene.instantiate()
		add_child(parallax_background)
	if arena_scene:
		var arena = arena_scene.instantiate()
		add_child(arena)
	# always the same (for now, who knows)
	var player_and_camera = PLAYER_CAMERA_COMBO.instantiate()
	add_child(player_and_camera)
	# just a test. this will be event-driven later, me thinks
	# after all, tutor may spawn later, or level without tutor, even
	var tutor = TUTOR.instantiate()
	add_child(tutor)
