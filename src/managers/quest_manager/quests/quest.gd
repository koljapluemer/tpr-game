class_name Quest extends Node2D

signal finished
signal started

@export_category("Conditions")
@export var delay_before_start = 0.0
@export var start_condition: Condition
@export var end_condition: Condition
#@export_category("Events")
#@export var demo_event: Event
# TODO: can I *not* smartly get those somewhere?
@export_category("Annoying Vars to keep independent")
@export var player: CharacterBody2D


var instruction: String


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
	Globals.quest_mngr.start_quest(self)
	
	if end_condition:
		end_condition.fulfilled.connect(_finish)

func _finish():
	finished.emit()
	if start_condition:
		start_condition.queue_free()
	if end_condition:
		end_condition.queue_free()
