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
	# quest listening (for audio)
	MessageManager.quest_started.connect(_on_quest_started)
	
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
	

func _on_quest_started(quest: Quest):
	if audio_stream_player_2d:
		var audio = "res://game/language/translation_audio/" + TranslationServer.get_locale() + "/" + str(quest) + ".mp3"
		if ResourceLoader.exists(audio):
			audio_stream_player_2d.stream = load(audio)
			audio_stream_player_2d.play()
		else:
			Logger.log(1,"audio does not exist: " + audio)
	else:
		push_warning("audio_player not found")
