class_name QuestWalkToNode extends Quest

@export var target: MapObject
@export var initially_hide_target = false
@export var give_demo = true

@onready var tutor: CharacterBody2D = get_tree().get_first_node_in_group("tutor") 

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
	
	if give_demo:
		# tutor demo
		var e_demo_walk = EventWalk.create(target, tutor)
		e_demo_walk.start_condition = c_object_appeared
		e_demo_walk.delay_before_start = 5
		add_child(e_demo_walk)
		
		var e_demo_talk = EventSay.create("GOING_" + target.key)
		e_demo_talk.delay_before_start = 4
		e_demo_talk.start_condition = c_object_appeared
		add_child(e_demo_talk)
		
		var c_talk_done = ConditionEventFinished.create(e_demo_talk)
		add_child(c_talk_done)
		var c_walk_done = ConditionEventFinished.create(e_demo_walk)
		add_child(c_walk_done)
		var c_demo_done = ConditionLogicAll.create([c_talk_done, c_talk_done])
		add_child(c_demo_done)
		
		quest_hot_condition = c_demo_done
	else:
		quest_hot_condition = c_object_appeared
	
	quest_hot_condition.delay_signal_by = 3
	
	# instruct and start quest
	instruction = "GO_" + target.key
	var e_demo_instruct = EventSay.create(instruction)
	e_demo_instruct.start_condition = quest_hot_condition
	add_child(e_demo_instruct)
	
	# success condition
	success_condition = ConditionBodyTouchedMapObject.create(player, target)
	add_child(success_condition)
	
	# defined in parent class 

	
	super()
	
