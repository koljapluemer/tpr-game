extends Node

# ADD LEVELS HERE
# /*
const _000_CUT_KIWI = preload("res://game/levels/level_templates/new/000_cut-kiwi.tscn")
# */

# add const value to the one below
const story: Array[PackedScene] = [
	_000_CUT_KIWI
]

const repeat_levels: Array[PackedScene] = [
	_000_CUT_KIWI	
]

# other constants
const END_LEVEL_SCREEN = preload("res://game/views/003_end_level_screen/end_level_screen.tscn")
const MAIN_MENU = preload("res://game/views/000_main_menu/new_main_menu.tscn")
const CREDITS = preload("res://game/views/002_credits/credits.tscn")

var current_level_index:int = 0

func load_scene(scene:PackedScene):
	_load_scene(scene)
	
func load_random_level():
	var lvl = story.pick_random()
	if lvl:
		_load_scene(lvl)

func load_end_level_screen():
	_load_scene(END_LEVEL_SCREEN)

func reload_level():
	_load_scene(story[current_level_index])

func load_next_story_level():
	if len(story) > current_level_index + 1:
		Logger.log(1, "loading next story level")
		current_level_index += 1
		_load_scene(story[current_level_index])
	else:
		# replay random level
		Logger.log(1,"loading random repeat level")
		_load_scene(repeat_levels.pick_random())
		

func load_level_by_index(i:int):
	if i <= len(story) - 1:
		current_level_index = i
		_load_scene(story[current_level_index])
	
func load_main_menu(): 
	_load_scene(MAIN_MENU)
	
func load_credits():
	_load_scene(CREDITS)

func _load_scene(scene:PackedScene):
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_packed(scene)
	
