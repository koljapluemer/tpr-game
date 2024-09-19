class_name QuestTakeNode extends Quest

@export var target: MapObjectInteractable

@export var give_demo = true
@export var move_target_after_demo: Node2D

var target_object_list:Array = []

@onready var tutor: CharacterBody2D = get_tree().get_first_node_in_group("tutor")

static func create(_target, _give_demo, _move_target_after_demo = null):
	var instance = QuestTakeNode.new()
	instance.target = _target
	instance.give_demo = _give_demo
	instance.move_target_after_demo = _move_target_after_demo
	return instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if success_condition:
		push_warning("QUEST - ", name, ": take quest should likely not have a manual end condition")
	if target:
		# target isn't just -the- target, it's key defines which objects can be taken
		# aka if target has key MELON, all objects with -group- KEY-MELON can be taken
		target_object_list = get_tree().get_nodes_in_group("KEY-" + target.key)
		print("found this many obj", len(target_object_list))
		
	super()
	
func _activate():
	# TODO: deadlock when player takes object before quest start
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
		var random_target_obj = target_object_list.pick_random()
		print("random target obj: ", random_target_obj)
		var e_demo_walk = EventTake.create(random_target_obj)
		e_demo_walk.start_condition = c_object_appeared
		e_demo_walk.delay_before_start = 3
		add_child(e_demo_walk)
		
		var e_demo_talk = EventSay.create("TAKING_" + target.key)
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
		
	
	quest_hot_condition.delay_signal_by = 3
	# instruct and start quest
	instruction = "TAKE_" + target.key
	var e_demo_instruct = EventSay.create(instruction)
	e_demo_instruct.start_condition = quest_hot_condition
	add_child(e_demo_instruct)
	
	# success condition
	
	# doing it w/o create init because that randomly fails again
	success_condition = ConditionBodyInteractedWithMapObjectWithGroup.new()
	success_condition.body = player
	success_condition.group_string = "KEY-" + target.key
	add_child(success_condition)
	# used in parent
	
	super()
	
