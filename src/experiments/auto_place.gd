extends Node2D

const ANCHOR = preload("res://src/components/level_elements/object/anchor.tscn")
const BACKPACK_BLUE = preload("res://src/components/level_elements/object/backpack_blue.tscn")
const BACKPACK_RED = preload("res://src/components/level_elements/object/backpack_red.tscn")
const BICYCLE = preload("res://src/components/level_elements/object/bicycle.tscn")
const BIKE = preload("res://src/components/level_elements/object/bike.tscn")
const CAR_BLUE = preload("res://src/components/level_elements/object/car_blue.tscn")
const CAR_BLUE_OLD = preload("res://src/components/level_elements/object/car_blue_old.tscn")
const CAR_RED_NISSAN_FRONT = preload("res://src/components/level_elements/object/car_red_nissan_front.tscn")
const CAR_RED_SIDE = preload("res://src/components/level_elements/object/car_red_side.tscn")
const CAR_SILVER = preload("res://src/components/level_elements/object/car_silver.tscn")
const CAR_TAXI = preload("res://src/components/level_elements/object/car_taxi.tscn")
const CAR_YELLOW = preload("res://src/components/level_elements/object/car_yellow.tscn")
const CAT = preload("res://src/components/level_elements/object/cat.tscn")
const CUPBOARD_1 = preload("res://src/components/level_elements/object/cupboard_1.tscn")
const CUPBOARD_2 = preload("res://src/components/level_elements/object/cupboard_2.tscn")
const DOG_SMALL = preload("res://src/components/level_elements/object/dog_small.tscn")
const DOG_TALL = preload("res://src/components/level_elements/object/dog_tall.tscn")

const objects = [ANCHOR, BACKPACK_BLUE, BACKPACK_RED, BICYCLE, BIKE, CAR_BLUE, CAR_BLUE_OLD, CAR_RED_NISSAN_FRONT, CAR_RED_SIDE, CAR_SILVER, CAR_TAXI, CAR_YELLOW, CAT, CUPBOARD_1, CUPBOARD_2, DOG_SMALL, DOG_TALL]

@onready var spawn_points: Node2D = %SpawnPoints

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for spawn_point in spawn_points.get_children():
		var obj_to_spawn = objects.pick_random()
		var obj = obj_to_spawn.instantiate()
		add_child(obj)
		obj.position = spawn_point.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
