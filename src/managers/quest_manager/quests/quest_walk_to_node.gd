class_name QuestWalkToNode extends Quest

@export var target: Node2D
@export var initially_hide_target = false
@export var tutor = CharacterBody2D

var e_demo_walk: EventWalk
var e_demo_talk: EventSay
var e_demo_instruct: EventSay


# TODO: how to handle whether demo is included?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initially_hide_target:
		target.hide()
	if end_condition:
		push_warning("QUEST - ", name, ": walk quest should likely not have a manual end condition")
	super()
	
func _activate():
	print("QUEST - ", name, ": activated")
	target.show()
	e_demo_walk = EventWalk.create(target, tutor)
	add_child(e_demo_walk)
	e_demo_walk.request_run()
	
	e_demo_talk = EventSay.create_from_map_object("Ich gehe ", target)
	add_child(e_demo_talk)
	e_demo_talk.request_run()
	
	e_demo_instruct = EventSay.create_from_map_object("Geh ", target)
	var condition_demo_finished = ConditionEventFinished.new()
	condition_demo_finished.event = e_demo_talk
	add_child(condition_demo_finished)
	e_demo_instruct.start_condition = condition_demo_finished
	add_child(e_demo_instruct)
	
