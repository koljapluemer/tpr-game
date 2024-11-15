extends Node

@export var levels:Array[Level] = []

const END_LEVEL_SCREEN = preload("res://game/ui/end_of_level/end_level_screen.tscn")
const CREDITS = preload("res://game/ui/credits/credits.tscn")
const LANGUAGE_MENU = preload("res://game/ui/language_menu/language_menu.tscn")
const MAIN_MENU = preload("res://game/ui/main_menu/main_menu.tscn")

const SCENE_MANAGER_LEVELS = preload("res://game/globals/scene_manager_levels.tres")

var current_level:PackedScene
var current_level_name:String

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
	var random_level: Level = SCENE_MANAGER_LEVELS.levels.pick_random()
	load_scene(random_level.scene)