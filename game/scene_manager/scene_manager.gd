extends Node

# ADD LEVELS HERE
# /*
const STORY_000_TOUCH_MELON = preload("res://game/levels/level_templates/story_000_touch_melon.tscn")
const STORY_001_TOUCH_TAKE_MELONS = preload("res://game/levels/level_templates/story_001_touch_take_melons.tscn")
const STORY_002_PUSH_SHOPPING_CART = preload("res://game/levels/level_templates/story_002_push_shopping_cart.tscn")
const STORY_003_INTERACT_WITH_LOTS_OF_FRUITS = preload("res://game/levels/level_templates/story_003_interact_with_lots_of_fruits.tscn")
const STORY_004_PUT_FRUIT_IN_BACKPACK = preload("res://game/levels/level_templates/story_004_put_fruit_in_backpack.tscn")
const STORY_005_CUT_KIWI = preload("res://game/levels/level_templates/story_005_cut_kiwi.tscn")
const STORY_006_MOVE_AROUND = preload("res://game/levels/level_templates/story_006_move_around.tscn")
const STORY_007_JUST_ONE_BUS = preload("res://game/levels/level_templates/story_007_just_one_bus.tscn")
const STORY_008_GET_ON_BUS = preload("res://game/levels/level_templates/story_008_get_on_bus.tscn")
const STORY_009_GET_ON_ONE_OF_THREE_BUSSES = preload("res://game/levels/level_templates/story_009_get_on_one_of_three_busses.tscn")

# */

# add const value to the one below
const story: Array[PackedScene] = [
	STORY_000_TOUCH_MELON,
	STORY_001_TOUCH_TAKE_MELONS,
	STORY_002_PUSH_SHOPPING_CART,
	STORY_003_INTERACT_WITH_LOTS_OF_FRUITS,
	STORY_004_PUT_FRUIT_IN_BACKPACK,
	STORY_005_CUT_KIWI,
	STORY_006_MOVE_AROUND,
	STORY_007_JUST_ONE_BUS,
	STORY_008_GET_ON_BUS,
	STORY_009_GET_ON_ONE_OF_THREE_BUSSES
]

# other constants
const END_LEVEL_SCREEN = preload("res://game/views/003_end_level_screen/end_level_screen.tscn")
const MAIN_MENU = preload("res://game/views/000_main_menu/main_menu.tscn")

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
	if len(story) > current_level_index:
		current_level_index += 1
		_load_scene(story[current_level_index])
	else:
		# replay random level
		_load_scene(story.pick_random())
		

func load_level_by_index(i:int):
	if i < len(story) - 1:
		current_level_index = i
		_load_scene(story[current_level_index])
	
func load_main_menu(): 
	_load_scene(MAIN_MENU)

func _load_scene(scene:PackedScene):
	print('resetting')
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_packed(scene)
	
