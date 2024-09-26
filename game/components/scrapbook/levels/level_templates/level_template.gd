## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this should
## be abstracted in the future.
extends Node2D

var interactions: Array[Interaction]
var scrapbook_objects: Array[ScrapbookObject]

@onready var spawn_points: Node2D = %SpawnPoints
#@onready var hot_bar: HotBar

# TODO: the damn hot_bar can get the interactions themselves, ideally by listening to signals
# which also allows dynamically updating the button bar...
func _ready() -> void:
	pass
	#hot_bar = get_tree().get_first_node_in_group("hot_bar")
	
	#if spawn_points:
		##get_afforded_interactions()
		#if hot_bar:
			#var buttons = hot_bar.set_buttons(interactions)
		#else:
			#push_error(name, ": HotBar missing")
	#else:
		#push_warning(name, ": SpawnPoints holder missing")
	
#func get_afforded_interactions():
	#for spawn_point:SpawnPoint in spawn_points.get_children():
		#spawn_point.spawn_scene()
		#scrapbook_objects.append(spawn_point.init_scene)
		#for mode in spawn_point.get_modes():
			#if not mode in interactions:
				#interactions.append(mode)
	#return interactions
