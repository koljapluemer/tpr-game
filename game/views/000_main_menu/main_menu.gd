extends Control

@export var topics: Array[Topic] = []

const TOPIC_RENDERER = preload("res://game/ui/topic_renderer.tscn")

@onready var play_button: Button = %PlayButton
@onready var level_container: VBoxContainer = %LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for topic in topics:
		var topic_renderer = TOPIC_RENDERER.instantiate()
		level_container.add_child(topic_renderer)
		topic_renderer.set_topic(topic)
		


#func _on_button_pressed() -> void:
	#SceneManager.reload_level()
#
#
#func _on_language_option_button_item_selected(index: int) -> void:
	#if index != -1:
		#play_button.disabled = false
		#level_select.disabled = false
		#match index:
			#0:
				#TranslationServer.set_locale("ar")
			#1:
				#TranslationServer.set_locale("de")
			#2:
				#TranslationServer.set_locale("it")
				#
#func _on_start_specific_level_button_pressed() -> void:
	#if level_select.selected != -1:
		#SceneManager.load_level_by_index(level_select.selected - 1)
#
#
#func _on_level_select_item_selected(index: int) -> void:
	## enable level start button but only if we have 
	## both a language and a level selected
	#if index != -1 and  not play_button.disabled:
		#start_specific_level_button.disabled = false


func _on_load_credits_pressed() -> void:
	SceneManager.load_credits()
