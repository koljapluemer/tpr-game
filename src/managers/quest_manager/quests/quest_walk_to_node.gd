class_name QuestWalkToNode extends Quest

@export var target: Node2D
@export var initially_hide_target = false
@export var tutor = CharacterBody2D

# TODO: how to handle whether demo is included?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initially_hide_target:
		target.hide()
	if success_condition:
		push_warning("QUEST - ", name, ": walk quest should likely not have a manual end condition")
	super()
	
func _activate():
	print("QUEST - ", name, ": activated")
	
	# appear object	
	var e_appear_object = EventAppear.create_from_map_object(target)
	add_child(e_appear_object)
	var c_object_appeared = ConditionEventFinished.new()
	c_object_appeared.event = e_appear_object
	add_child(c_object_appeared)
	e_appear_object.request_run()

	# tutor demo
	var e_demo_walk = EventWalk.create(target, tutor)
	e_demo_walk.start_condition = c_object_appeared
	e_demo_walk.delay_before_start = 3
	add_child(e_demo_walk)
	
	var e_demo_talk = EventSay.create_from_map_object("Ich gehe ", target)
	e_demo_walk.delay_before_start = 2
	e_demo_talk.start_condition = c_object_appeared
	add_child(e_demo_talk)
	
	var c_talk_done = ConditionEventFinished.create(e_demo_talk)
	add_child(c_talk_done)
	var c_walk_done = ConditionEventFinished.create(e_demo_walk)
	add_child(c_walk_done)
	var c_demo_done = ConditionLogicAll.create([c_talk_done, c_talk_done])
	add_child(c_demo_done)
	
	# instruct and start quest
	
	var e_demo_instruct = EventSay.create_from_map_object("Geh ", target)
	instruction = "Geh " + target.item.dative_form
	e_demo_instruct.start_condition = c_demo_done
	add_child(e_demo_instruct)
	
	# success condition
	success_condition = ConditionBodyTouchedMapObject.create(player, target)
	add_child(success_condition)
	
	# defined in parent class 
	quest_hot_condition = c_demo_done

	
	super()
	
