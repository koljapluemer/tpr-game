## A [SpawnPoint] can be placed in a [LevelTemplate].
## It holds a list of acceptable objects, of which it will pick one
## when the level starts and spawns it.
## This in the end will inform which quests can be done 
## in a level.
class_name SpawnPoint extends Marker2D

@export var accepts: Array[PackedScene] = []
@export var scale_factor: float = 1


@export var uniqueness_id:String
@export var relative_position:String
@export var relative_position_relates_to_spawn_point:SpawnPoint

var init_scene: ScrapbookObject
var used_packed_scene: PackedScene

func _ready() -> void:
	pass


func spawn_in_random_object() -> ScrapbookObject:
	var acceptable_scenes := accepts
	if len(uniqueness_id) > 0:
		add_to_group(uniqueness_id)
		for other_spawn_point_with_same_id : SpawnPoint in get_tree().get_nodes_in_group(uniqueness_id):
			acceptable_scenes.erase(other_spawn_point_with_same_id.used_packed_scene)
	
	var scene_to_init:PackedScene = acceptable_scenes.pick_random()
	Logger.log(0, name + ": randomly selected scene to init: " + str(scene_to_init), ["SPAWN"])
	if not scene_to_init:
		push_warning(name, ": no scenes set to spawn")
		return null
	else:
		used_packed_scene = scene_to_init
		return change_scene(scene_to_init)
	

func change_scene_to_path(path:String) -> void:
	change_scene(load(path))

func change_scene(scene_to_init:PackedScene) -> ScrapbookObject:
	init_scene = scene_to_init.instantiate()
	init_scene.scale = Vector2(scale_factor, scale_factor)
	init_scene.z_index = z_index
	init_scene.parent_spawn_point = self
	owner.add_child(init_scene)
	init_scene.global_position = global_position
	Logger.log(1, name + ": set scene of spawnpoint to: " + init_scene.name, ["SPAWN", "NEW-QUESTS"])
	return init_scene
