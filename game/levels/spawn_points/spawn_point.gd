## A [SpawnPoint] can be placed in a [LevelTemplate].
## It holds a list of acceptable objects, of which it will pick one
## when the level starts and spawns it.
## This in the end will inform which quests can be done 
## in a level.
class_name SpawnPoint extends Marker2D

@export var accepts: Array[PackedScene] = []
@export var scale_factor: float = 1

var init_scene: ScrapbookObject

func _ready() -> void:
	call_deferred("spawn_in_random_object")
	

func spawn_in_random_object():
	var scene_to_init = accepts.pick_random()
	if not scene_to_init:
		push_warning(name, ": no scenes set to spawn")
		return
	var inst = scene_to_init.instantiate()
	inst.scale = Vector2(scale_factor, scale_factor)
	inst.z_index = 0
	init_scene = inst as ScrapbookObject
	add_child(inst)
	MessageManager.object_appeared.emit(inst)

func get_modes():
	# awkward pass-through function
	# but I guess in the end the spawn points have responsibility 
	# for the created scenes
	return init_scene.get_affordances()