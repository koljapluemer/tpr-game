extends Node2D

@export var possible_objects:Array[TakeableObject] = []

const TAKEABLE_OBJECT = preload("res://alchemy/001_test/takeable_object.tscn")

var currentMode: InteractionMode
var objects: Array[TakeableObject] = []
var spawn_area
var spawn_origin
var quest_active = false
var current_target:String

@onready var hot_bar: GridContainer = %HotBar
@onready var mode_debug: Label = %ModeDebug
@onready var spawn_area_object: CollisionShape2D = %SpawnArea
@onready var dialog_manager: DialogManager = $DialogManager

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
	var random_item = possible_objects.pick_random()
	var inst = random_item.instantiation.instantiate()
	var x = randi_range(spawn_origin.x, spawn_area.x)
	var y = randi_range(spawn_origin.y, spawn_area.y)
	inst.global_position.x = x
	inst.global_position.y = y
	add_child(inst)
	objects.append(inst)
	#inst.object_destroyed.connect(_on_obj_destroyed)

func _on_obj_destroyed(obj):
	objects.erase(obj)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_quest():
	if not quest_active:
		quest_active = true
		current_target = objects.pick_random()
		if current_target == "APPLE":
			dialog_manager.say("TAKE_AN_APPLE")
		else:	
			dialog_manager.say("TAKE_A_" + current_target)
