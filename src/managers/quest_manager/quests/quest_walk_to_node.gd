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
	
	var e_appear_object = EventAppear.create_from_map_object(target)
	add_child(e_appear_object)
	var c_object_appeared = ConditionEventFinished.new()
	c_object_appeared.event = e_appear_object
	add_child(c_object_appeared)
	e_appear_object.request_run()

	e_demo_walk = EventWalk.create(target, tutor)
	e_demo_walk.start_condition = c_object_appeared
	e_demo_walk.delay_before_start = 3
	add_child(e_demo_walk)
	
	e_demo_talk = EventSay.create_from_map_object("Ich gehe ", target)
	e_demo_walk.delay_before_start = 2
	e_demo_talk.start_condition = c_object_appeared
	add_child(e_demo_talk)
	
	e_demo_instruct = EventSay.create_from_map_object("Geh ", target)
	instruction = "Geh " + target.item.dative_form
	var condition_demo_finished = ConditionEventFinished.new()
	condition_demo_finished.event = e_demo_talk
	# TODO: *could* make sure that both demo talk and walk finished with condition_logic_all 
	add_child(condition_demo_finished)
	e_demo_instruct.start_condition = condition_demo_finished
	add_child(e_demo_instruct)
	
	super()
	
