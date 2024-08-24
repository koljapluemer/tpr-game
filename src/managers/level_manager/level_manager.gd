extends Node

const _001_LEARN_MOVE = preload("res://src/levels/play/001_learn_move.tscn")
const _002_TRAM_BUS = preload("res://src/levels/play/002_tram_bus.tscn")
const _003_BIKE_BICYCLE = preload("res://src/levels/play/003_bike_bicycle.tscn")
const _004_B_BATHROOM_CLUSTER = preload("res://src/levels/play/004_b_bathroom_cluster.tscn")
const _005_CAR_COLORS = preload("res://src/levels/play/005_car_colors.tscn")
const _006_LEFT_RIGHT = preload("res://src/levels/play/006_left-right.tscn")
const _007_LEARN_INTERACT = preload("res://src/levels/play/007_learn_interact.tscn")
const _008_LEARN_TAKE = preload("res://src/levels/play/008_learn_take.tscn")

const levels: Array[PackedScene] = [
	_001_LEARN_MOVE,
	_002_TRAM_BUS,
	_003_BIKE_BICYCLE,
	_004_B_BATHROOM_CLUSTER,
	_006_LEFT_RIGHT,
	_005_CAR_COLORS,
	_007_LEARN_INTERACT,
	_008_LEARN_TAKE
]

var next_level = 0

func load_next_level():
	print("loading next level, nr of lvl: ", len(levels))
	if next_level < len(levels):
		get_tree().change_scene_to_packed(levels[next_level])
		next_level += 1