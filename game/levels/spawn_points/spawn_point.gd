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
	# deferred because otherwise danger that we send out a signal
	# that noone is listening to yet
	call_deferred("spawn_in_random_object")
	

func spawn_in_random_object():
	var scene_to_init = accepts.pick_random()
	if not scene_to_init:
		push_warning(name, ": no scenes set to spawn")
	else:
		change_scene(scene_to_init)
	

func change_scene(scene_to_init:PackedScene):
	print("changing scene")
	var inst:ScrapbookObject = scene_to_init.instantiate()
	inst.scale = Vector2(scale_factor, scale_factor)
	inst.z_index = 0
	inst.grid_pos = grid_pos
	add_child(inst)
	MessageManager.object_appeared.emit(inst)
