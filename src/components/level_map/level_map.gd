@tool
class_name LevelMap extends Node2D
# effectively a per-level game manager

signal level_started

@export var parallax_background_scene: PackedScene
@export var arena_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_started.emit()
	# scenes with props
	if parallax_background_scene:
		var parallax_background = parallax_background_scene.instantiate()
		add_child(parallax_background)
	if arena_scene:
		var arena = arena_scene.instantiate()
		add_child(arena)
	# always the same (for now, who knows)
	# also dumb, instead of class_name memes could just add as a scene and not have this shit
