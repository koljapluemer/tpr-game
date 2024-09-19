extends Node2D

@onready var apple_spawn_area_object = %AppleSpawnArea
const APPLE = preload("res://src/level_stocking_shelves/apple.tscn")

var apple_spawn_area
var apple_spawn_origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apple_spawn_area = apple_spawn_area_object.shape.extents
	apple_spawn_origin = apple_spawn_area_object.global_position -  apple_spawn_area
	spawn_apples()

func spawn_apples():
	for i in range(20):
		spawn_apple()

func spawn_apple():
	var inst = APPLE.instantiate()
	var x = randi_range(apple_spawn_origin.x, apple_spawn_area.x)
	var y = randi_range(apple_spawn_origin.y, apple_spawn_area.y)
	inst.global_position.x = x
	inst.global_position.y = y
	add_child(inst)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
