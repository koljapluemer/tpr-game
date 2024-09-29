extends Node

# ADD LEVELS HERE
# /*
const STORY_000_TOUCH_MELON = preload("res://game/levels/level_templates/story_000_touch_melon.tscn")
const STORY_001_TOUCH_TAKE_MELONS = preload("res://game/levels/level_templates/story_001_touch_take_melons.tscn")
const STORY_002_PUSH_SHOPPING_CART = preload("res://game/levels/level_templates/story_002_push_shopping_cart.tscn")
const STORY_003_INTERACT_WITH_LOTS_OF_FRUITS = preload("res://game/levels/level_templates/story_003_interact_with_lots_of_fruits.tscn")
const STORY_004_PUT_FRUIT_IN_BACKPACK = preload("res://game/levels/level_templates/story_004_put_fruit_in_backpack.tscn")
const STORY_005_CUT_KIWI = preload("res://game/levels/level_templates/story_005_cut_kiwi.tscn")
const STORY_006_JUST_YOU_MOVE_AROUND = preload("res://game/levels/level_templates/story_006_just_you_move_around.tscn")
const STORY_006_MOVE_AROUND = preload("res://game/levels/level_templates/story_006_move_around.tscn")
const STORY_007_JUST_ONE_BUS = preload("res://game/levels/level_templates/story_007_just_one_bus.tscn")
const STORY_008_GET_ON_BUS = preload("res://game/levels/level_templates/story_008_get_on_bus.tscn")
const STORY_009_GET_ON_ONE_OF_THREE_BUSSES = preload("res://game/levels/level_templates/story_009_get_on_one_of_three_busses.tscn")

# */

# add const value to the one below
#const playable_levels: Array[PackedScene] = [FRUIT_TABLE, FRUIT_TABLE2, STREET, BUS_TERMINAL_2, PICK_ONE_FRUIT_FROM_TABLE]
const playable_levels: Array[PackedScene] = [STORY_009_GET_ON_ONE_OF_THREE_BUSSES]

# other constants
const END_LEVEL_SCREEN = preload("res://game/views/003_end_level_screen/end_level_screen.tscn")

func load_scene(scene:PackedScene):
	get_tree().change_scene_to_packed(scene)
	
func load_random_level():
	var lvl = playable_levels.pick_random()
	if lvl:
		get_tree().change_scene_to_packed(lvl)

func load_end_level_screen():
	get_tree().change_scene_to_packed(END_LEVEL_SCREEN)
