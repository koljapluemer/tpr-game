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
					scrapbook_objects.append(spawned_obj)
					MessageManager.object_list_changed.emit(scrapbook_objects)
			else:
				push_warning("spawn_point is missing method")
		if quest_manager:
			Logger.log(0, "telling quest manager to run initial setup", ["NEW-QUESTS"])
			quest_manager.initial_setup(scrapbook_objects)
		else:
			push_warning("no quest_manager_found")
			
	MessageManager.object_stopped_moving.connect(_on_object_stopped_moving)
	MessageManager.object_started_moving.connect(_on_object_started_moving)
	
	
func _on_object_started_moving(moving_object:ScrapbookObject):
	for obj in scrapbook_objects:
		if is_instance_valid(obj):
			if not obj == moving_object:
				obj.modulate.a = 0.7
		else:
			scrapbook_objects.erase(obj)
	
func _on_object_stopped_moving(moving_object:ScrapbookObject):
	for obj in scrapbook_objects:
		if is_instance_valid(obj):
			obj.modulate.a = 1
		else:
			scrapbook_objects.erase(obj)
		
