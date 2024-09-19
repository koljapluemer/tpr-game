extends Node2D

const APPLE = preload("res://supermarket_game_test/level_stocking_shelves/apple.tscn")
const PEAR = preload("res://supermarket_game_test/level_stocking_shelves/pear.tscn")
const FRUIT = [APPLE, PEAR]
const SPAWN_DELAY = 0.02

var apple_spawn_area
var apple_spawn_origin
var apples = []


@onready var dialog_manager: DialogManager = get_tree().get_first_node_in_group("dialog_manager")
@onready var apple_spawn_area_object = %AppleSpawnArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apple_spawn_area = apple_spawn_area_object.shape.extents
	apple_spawn_origin = apple_spawn_area_object.global_position -  apple_spawn_area
	spawn_objects()
	dialog_manager.say("TAKE_AN_APPLE")

func spawn_objects():
	var obj_to_inst = FRUIT.pick_random()
	var inst = obj_to_inst.instantiate()
	var x = randi_range(apple_spawn_origin.x, apple_spawn_area.x)
	var y = randi_range(apple_spawn_origin.y, apple_spawn_area.y)
	inst.global_position.x = x
	inst.global_position.y = y
	add_child(inst)
	apples.append(inst)
	
	if len(apples) < 20:
		get_tree().create_timer(SPAWN_DELAY).connect("timeout", spawn_objects)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
