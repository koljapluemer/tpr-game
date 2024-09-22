extends Marker2D

@export var accepts: Array[PackedScene] = []
@export var scale_factor: float = 1


func _ready() -> void:
	var scene_to_init:AlchemyObject = accepts.pick_random()
	if scene_to_init:
		var inst:Node2D = scene_to_init.instantiate()
		inst.scale = Vector2(scale_factor, scale_factor)
		inst.z_index = 0
		add_child(inst)
	else:
		push_warning(name, ": no scenes set to spawn")
