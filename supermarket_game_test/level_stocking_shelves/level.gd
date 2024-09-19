extends Node2D


const APPLE = preload("res://supermarket_game_test/level_stocking_shelves/apple.tscn")
const PEAR = preload("res://supermarket_game_test/level_stocking_shelves/pear.tscn")
const FRUIT = [APPLE, PEAR]
const QUEST_TARGETS = ["APPLE", "PEAR"]
const SPAWN_DELAY = 0.02

var fruit_spawn_area
var fruit_spawn_origin
var fruits = []

var current_target:String
var quest_active = false


@onready var dialog_manager: DialogManager = get_tree().get_first_node_in_group("dialog_manager")
@onready var fruit_spawn_area_object = %AppleSpawnArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fruit_spawn_area = fruit_spawn_area_object.shape.extents
	fruit_spawn_origin = fruit_spawn_area_object.global_position -  fruit_spawn_area
	spawn_objects()
	set_quest()

func spawn_objects():
	var obj_to_inst = FRUIT.pick_random()
	var inst = obj_to_inst.instantiate()
	var x = randi_range(fruit_spawn_origin.x, fruit_spawn_area.x)
	var y = randi_range(fruit_spawn_origin.y, fruit_spawn_area.y)
	inst.global_position.x = x
	inst.global_position.y = y
	add_child(inst)
	fruits.append(inst)
	inst.object_clicked.connect(_on_object_clicked)
	
	if len(fruits) < 20:
		get_tree().create_timer(SPAWN_DELAY).connect("timeout", spawn_objects)
	
func _on_object_clicked(obj:Node2D):
	if obj.is_in_group(current_target):
		quest_active = false
		obj.queue_free()
		set_quest()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_quest():
	if not quest_active:
		quest_active = true
		current_target = QUEST_TARGETS.pick_random()
		if current_target == "APPLE":
			dialog_manager.say("TAKE_AN_APPLE")
		else:	
			dialog_manager.say("TAKE_A_" + current_target)
			
		
