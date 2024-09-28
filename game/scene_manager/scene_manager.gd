extends Node

# ADD LEVELS HERE
# /*
const FRUIT_TABLE = preload("res://game/levels/level_templates/level_templates/001_fruit_table/fruit_table.tscn")
const FRUIT_TABLE2 = preload("res://game/levels/level_templates/level_templates/002_fruit_table_many/fruit_table.tscn")
const STREET = preload("res://game/levels/level_templates/level_templates/003_single_car/street.tscn")
const BUS_TERMINAL_2 = preload("res://game/levels/level_templates/level_templates/005_bus_terminal_2/bus_terminal_2.tscn")
const PICK_ONE_FRUIT_FROM_TABLE = preload("res://game/levels/level_templates/level_templates/006_pick_one_fruit_from_table/pick_one_fruit_from_table.tscn")

# */

# add const value to the one below
const playable_levels: Array[PackedScene] = [FRUIT_TABLE, FRUIT_TABLE2, STREET, BUS_TERMINAL_2, PICK_ONE_FRUIT_FROM_TABLE]

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
