extends Node2D

var currentMode: InteractionMode
var objects: Array[TakeableObject] = []
var spawn_area
var spawn_origin

@onready var hot_bar: GridContainer = %HotBar
@onready var mode_debug: Label = %ModeDebug
@onready var spawn_area_object: CollisionShape2D = %SpawnArea

const TAKEABLE_OBJECT = preload("res://alchemy/001_test/takeable_object.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in hot_bar.get_children():
		button.mode_button_pressed.connect(_on_mode_button_pressed)
	spawn_objects()

func _on_mode_button_pressed(mode):
	currentMode = mode
	mode_debug.text = currentMode.mode

func spawn_objects():
	spawn_area = spawn_area_object.shape.extents
	spawn_origin = spawn_area_object.global_position -  spawn_area
	for i in range(10):
		spawn_object()
	
func spawn_object():
	var inst = TAKEABLE_OBJECT.instantiate()
	var x = randi_range(spawn_origin.x, spawn_area.x)
	var y = randi_range(spawn_origin.y, spawn_area.y)
	inst.global_position.x = x
	inst.global_position.y = y
	add_child(inst)
	objects.append(inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
