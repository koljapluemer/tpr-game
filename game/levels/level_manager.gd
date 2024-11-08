## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this could
## be abstracted in the future.
class_name LevelManager extends Node2D

@export var level_name:String
@export_multiline var learning_goal:String ## internal documentation

var scrapbook_objects: Array[ScrapbookObject]

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var spawn_points: Node2D = %SpawnPoints
@onready var quest_manager: QuestManager = %QuestManager


func _ready() -> void:	
	# setup of spawnpoints and quests
	if not spawn_points:
		push_error("level has no spawn_points object")
	else:
		for spawn_point:SpawnPoint in spawn_points.get_children():
			if spawn_point.has_method("spawn_in_random_object"):
				var spawned_obj := spawn_point.spawn_in_random_object()
				if spawned_obj:
					_register_scrapbook_obj(spawned_obj)
			else:
				push_warning("spawn_point is missing method")
		if quest_manager:
			Logger.log(0, "telling quest manager to run initial setup", ["NEW-QUESTS"])
			quest_manager.initial_setup(scrapbook_objects)
		else:
			push_warning("no quest_manager_found")
			
	MessageManager.object_appeared.connect(_register_scrapbook_obj)

func _register_scrapbook_obj(obj:ScrapbookObject):
	if not obj in scrapbook_objects:
		MessageManager.object_list_changed.emit(scrapbook_objects)
		scrapbook_objects.append(obj)
		obj.hover_hint_state_changed_to.connect(_on_hover_hint_state_changed_to)


func _on_hover_hint_state_changed_to(active_obj:ScrapbookObject, passive_obj:ScrapbookObject):
	print("hover state changed: ", active_obj, passive_obj)
	for obj in scrapbook_objects:
		if is_instance_valid(obj):
			if not obj == active_obj and not obj == passive_obj:
				obj.modulate.a = 0.5
			else:
				obj.modulate.a = 1
		else:
			scrapbook_objects.erase(obj)
