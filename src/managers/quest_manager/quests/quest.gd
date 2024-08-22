class_name Quest extends Node2D

signal finished
signal started

@export_category("Conditions")
@export var delay_before_start = 0.0
@export var start_condition: Condition
@export var success_condition: Condition
#@export_category("Events")
#@export var demo_event: Event
# TODO: can I *not* smartly get those somewhere?
@export_category("Annoying Vars to keep independent")
@export var player: CharacterBody2D

# TODO: magic number that is manually syned w/ another manual delay in quest_walk_to_node
const delay_unitl_manager_is_informed = 3.5

var instruction: String
var quest_hot_condition: Condition

@onready var quest_manager: QuestManager = get_tree().get_first_node_in_group("quest_manager")

func _ready():
	if not player:
		push_warning("QUEST - ", name, ": no player set")
	if not start_condition:
		push_warning("QUEST - ", name, ": quest has no start condition")
	else:
		print(name, " connecting to start connection: ",start_condition.name)
		start_condition.fulfilled.connect(request_activation)
	

# FIY: following three function are very similar to event.gd
func request_activation():
	print("QUEST - ", "quest activation requested: ", name)
	get_tree().create_timer(delay_before_start).connect("timeout", _activate)
	

func _activate():
	if not quest_hot_condition:
		push_warning(name, ": no condition to set quest hot")
	else:
		quest_hot_condition.fulfilled.connect(_on_quest_hot)


func _on_quest_hot():
	get_tree().create_timer(delay_unitl_manager_is_informed).connect("timeout", _call_quest_mngr)
	if success_condition:
		success_condition.fulfilled.connect(_finish)


func _call_quest_mngr():
	quest_manager.start_quest(self)
	

func _finish():
	finished.emit()
	quest_manager.finish_quest(self)
	#if start_condition:
		#start_condition.queue_free()
	#if success_condition:
		#success_condition.queue_free()
