## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this should
## be abstracted in the future.
extends Node2D

var interactions: Array[Interaction]
var scrapbook_objects: Array[ScrapbookObject]

@onready var spawn_points: Node2D = %SpawnPoints
@onready var hot_bar: HotBar
@onready var quest_manager: QuestManager = %QuestManager

func _ready() -> void:
	hot_bar = get_tree().get_first_node_in_group("hot_bar")
	
	if spawn_points:
		get_afforded_interactions()
		if hot_bar:
			var buttons = hot_bar.set_buttons(interactions)
		else:
			push_error(name, ": HotBar missing")
		
		quest_manager.quest_finished.connect(_on_quest_finished)
		start_new_quest()
	else:
		push_warning(name, ": SpawnPoints holder missing")
	
func _on_quest_finished(_quest:Quest):
	get_tree().create_timer(0.3).connect("timeout", start_new_quest)
	
func start_new_quest():
	quest_manager.generate_possible_quests(scrapbook_objects)
	quest_manager.start_random_quest()

func get_afforded_interactions():
	for spawn_point:SpawnPoint in spawn_points.get_children():
		spawn_point.spawn_scene()
		scrapbook_objects.append(spawn_point.init_scene)
		for mode in spawn_point.get_modes():
			if not mode in interactions:
				interactions.append(mode)
	return interactions