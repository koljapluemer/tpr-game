extends Control

@export var topics: Array[Topic] = []
var unlocked_topics: Array[Topic] = []

const TOPIC_RENDERER = preload("res://game/ui/topic_renderer.tscn")

var topic_renderers:Array[TopicRenderer]

@onready var change_lang_button: Button = %ChangeLangButton
@onready var level_container: VBoxContainer = %LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PlayerPreferencesManager.get_pref_language_code():
		SceneManager.load_language_change_screen()
	change_lang_button.text = "(" + PlayerPreferencesManager.get_pref_language_code() + ") Change Language"
	for topic in topics:
		var topic_renderer = TOPIC_RENDERER.instantiate()
		level_container.add_child(topic_renderer)
		topic_renderer.set_topic(topic)
		topic_renderer.set_points(LanguageLearningDataManager.get_topic_data_by_name(topic.internal_name).points)
		topic_renderers.append(topic_renderer)
		if not topic_renderer.is_locked:
			unlocked_topics.append(topic)
		
	MessageManager.topic_changed_to.connect(_on_topic_changed)
	
	# for now, just select/highlight a random topic
	SceneManager.change_topic_to(unlocked_topics.pick_random())

func _on_load_credits_pressed() -> void:
	SceneManager.load_credits()


func _on_change_lang_button_pressed() -> void:
	SceneManager.load_language_change_screen()

func _on_topic_changed(topic:Topic):
	print('reacting to topic change')
	for topic_renderer in topic_renderers:
		if SceneManager.current_topic == topic_renderer.topic:
			topic_renderer.main_button.button_pressed = true
		else:
			topic_renderer.main_button.button_pressed = false
			

func _on_play_button_pressed() -> void:
	SceneManager.load_play_level()
