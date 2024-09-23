## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this should
## be abstracted in the future.
extends Node2D

var interactions: Array[Interaction]

@onready var spawn_points: Node2D = %SpawnPoints
@onready var hot_bar: HotBar

func _ready() -> void:
	hot_bar = get_tree().get_first_node_in_group("hot_bar")
	
	if spawn_points:
		get_afforded_interactions()
		
		if hot_bar:
			hot_bar.set_buttons(interactions)
		else:
			push_error(name, ": HotBar missing")
	else:
		push_warning(name, ": SpawnPoints holder missing")
	

func get_afforded_interactions():
	for spawn_point:SpawnPoint in spawn_points.get_children():
		spawn_point.spawn_scene()
		for mode in spawn_point.get_modes():
			if not mode in interactions:
				interactions.append(mode)
	return interactions

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
