extends Node

# add levels here

const FRUIT_TABLE = preload("res://game/levels/level_templates/level_templates/001_fruit_table/fruit_table.tscn")
const FRUIT_TABLE2 = preload("res://game/levels/level_templates/level_templates/002_fruit_table_many/fruit_table.tscn")
const STREET = preload("res://game/levels/level_templates/level_templates/003_single_car/street.tscn")

const playable_levels: Array[PackedScene] = [FRUIT_TABLE, FRUIT_TABLE2, STREET]

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
