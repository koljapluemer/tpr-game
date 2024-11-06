## A [SpawnPoint] can be placed in a [LevelTemplate].
## It holds a list of acceptable objects, of which it will pick one
## when the level starts and spawns it.
## This in the end will inform which quests can be done 
## in a level.
class_name SpawnPoint extends Marker2D

@export var accepts: Array[PackedScene] = []
@export var scale_factor: float = 1
@export var grid_pos:Vector2

var init_scene: ScrapbookObject

func _ready() -> void:
	pass


func spawn_in_random_object() -> ScrapbookObject:
	var scene_to_init:PackedScene = accepts.pick_random()
	Logger.log(0, name + ": randomly selected scene to init: " + str(scene_to_init), ["SPAWN"])
	if not scene_to_init:
		push_warning(name, ": no scenes set to spawn")
		return null
	else:
		return change_scene(scene_to_init)
	

func change_scene_to_path(path:String) -> void:
	change_scene(load(path))

func change_scene(scene_to_init:PackedScene) -> ScrapbookObject:
	init_scene = scene_to_init.instantiate()
	init_scene.scale = Vector2(scale_factor, scale_factor)
	init_scene.z_index = 0
	init_scene.grid_pos = grid_pos
	init_scene.parent_spawn_point = self
	add_child(init_scene)
	Logger.log(1, name + ": set scene of spawnpoint to: " + init_scene.name, ["SPAWN", "NEW-QUESTS"])
	return init_scene
