class_name QuestInteractWithNode extends Quest

@export var target: MapObjectInteractable
@export var initially_hide_target = false

@export var give_demo = true
@export var move_target_after_demo: Node2D

@onready var tutor: CharacterBody2D = get_tree().get_first_node_in_group("tutor")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initially_hide_target:
		target.hide()
	if success_condition:
		push_warning("QUEST - ", name, ": interact quest should likely not have a manual end condition")
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
	
	if give_demo:
		# tutor demo
		var e_demo_walk = EventInteract.create(target)
		e_demo_walk.start_condition = c_object_appeared
		e_demo_walk.delay_before_start = 3
		add_child(e_demo_walk)
		
		var e_demo_talk = EventSay.create(target.interact_demo)
		e_demo_walk.delay_before_start = 2
		e_demo_talk.start_condition = c_object_appeared
		add_child(e_demo_talk)
		
		var c_talk_done = ConditionEventFinished.create(e_demo_talk)
		add_child(c_talk_done)
		var c_walk_done = ConditionEventFinished.create(e_demo_walk)
		add_child(c_walk_done)
		var c_demo_done = ConditionLogicAll.create([c_talk_done, c_talk_done])
		add_child(c_demo_done)
		
		if move_target_after_demo:
			var e_demo_walk_away = EventWalk.create(move_target_after_demo, tutor)
			e_demo_walk_away.start_condition = c_demo_done
			e_demo_walk_away.delay_before_start = 2
			add_child(e_demo_walk_away)
			
		quest_hot_condition = c_demo_done
	else:
		quest_hot_condition = c_object_appeared
		
	
	# instruct and start quest
	instruction = target.interact_prompt
	var e_demo_instruct = EventSay.create(instruction)
	e_demo_instruct.start_condition = quest_hot_condition
	# TODO: fix magic number
	# this is the time between demo and task given to player
	e_demo_instruct.delay_before_start = 3
	add_child(e_demo_instruct)
	
	# success condition
	success_condition = ConditionBodyInteractedWithMapObject.create(player, target)
	add_child(success_condition)
	# used in parent
	
	super()
	
