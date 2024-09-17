extends Node2D

const APPLE = preload("res://src/components/level_elements/object/apple.tscn")
const COCONUT = preload("res://src/components/level_elements/object/coconut.tscn")
const PEAR = preload("res://src/components/level_elements/object/pear.tscn")
const MELON = preload("res://src/components/level_elements/object/melon.tscn")

const objects = [APPLE, COCONUT, PEAR, MELON]
@onready var spawn_points: Node2D = %SpawnPoints
@onready var tool_spawn_points: Node2D = %ToolSpawnPoints

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for spawn_point in spawn_points.get_children():
		var obj_to_spawn = objects.pick_random()
		var obj = obj_to_spawn.instantiate()
		add_child(obj)
		obj.global_position = spawn_point.global_position
	for spawn_point in tool_spawn_points.get_children():
		var obj_to_spawn = objects.pick_random()
		var obj = obj_to_spawn.instantiate()
		add_child(obj)
		obj.global_position = spawn_point.global_position
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
