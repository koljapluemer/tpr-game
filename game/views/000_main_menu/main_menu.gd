extends Control

@export var topics: Array[Topic] = []

const TOPIC_RENDERER = preload("res://game/ui/topic_renderer.tscn")

@onready var change_lang_button: Button = %ChangeLangButton
@onready var play_button: Button = %PlayButton
@onready var level_container: VBoxContainer = %LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_lang_button.text = "(" + TranslationServer.get_locale() + ") Change Language"
	for topic in topics:
		var topic_renderer = TOPIC_RENDERER.instantiate()
		level_container.add_child(topic_renderer)
		topic_renderer.set_topic(topic)


func _on_load_credits_pressed() -> void:
	SceneManager.load_credits()


func _on_change_lang_button_pressed() -> void:
	SceneManager.load_language_change_screen()
