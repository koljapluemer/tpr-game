## A screen to be shown at the end of the level
## is currently called by a [QuestManager] when a certain nr. of quests are done
## or no quests are possible.
## At a later point, it may show statistics, etc.
## Right now, it just gives a very very simple UI allowing to go to the next level.
extends Control
@onready var points_label: Label = %PointsLabel

func _ready() -> void:
	var score = randi_range(3, 10)
	LanguageLearningDataManager.earn_points_for_topic(SceneManager.current_topic, score)
	points_label.text = '+' + str(score) + ' points'

func _on_button_play_next_pressed() -> void:
	SceneManager.load_play_level()


func _on_button_replay_pressed() -> void:
	SceneManager.reload_level()


func _on_button_menu_pressed() -> void:
	SceneManager.load_main_menu()
