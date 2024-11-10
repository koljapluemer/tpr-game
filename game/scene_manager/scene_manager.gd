extends Node

# other constants
const END_LEVEL_SCREEN = preload("res://game/views/003_end_level_screen/end_level_screen.tscn")
const MAIN_MENU = preload("res://game/views/000_main_menu/new_main_menu.tscn")
const CREDITS = preload("res://game/views/002_credits/credits.tscn")
const LANGUAGE_MENU = preload("res://game/views/000_main_menu/language_menu.tscn")

var current_topic:Topic
var current_level:PackedScene

func load_scene(scene:PackedScene):
	_load_scene(scene)

func load_end_level_screen():
	_load_scene(END_LEVEL_SCREEN)

func reload_level():
	_load_scene(current_level)


func load_main_menu(): 
	_load_scene(MAIN_MENU)
	
func load_credits():
	_load_scene(CREDITS)

func _load_scene(scene:PackedScene):
	get_tree().change_scene_to_packed(scene)

func load_language_change_screen():	
	_load_scene(LANGUAGE_MENU)
	
func load_play_level():
	load_scene(current_topic.level_rotation.pick_random())

func change_topic_to(topic:Topic):
	current_topic = topic
	MessageManager.topic_changed_to.emit(topic)
