class_name SpawnPoint extends Marker2D

@export var accepts: Array[PackedScene] = []
@export var scale_factor: float = 1

var init_scene:AlchemyObject

func _ready() -> void:
	var scene_to_init = accepts.pick_random()
	if scene_to_init:
		var inst = scene_to_init.instantiate()
		inst.scale = Vector2(scale_factor, scale_factor)
		inst.z_index = 0
		init_scene = inst as AlchemyObject
		add_child(inst)
	else:
		push_warning(name, ": no scenes set to spawn")

func get_modes():
	# awkward pass-through function
	# but I guess in the end the spawn points have responsibility 
	# for the created scenes
	return init_scene.get_modes()
