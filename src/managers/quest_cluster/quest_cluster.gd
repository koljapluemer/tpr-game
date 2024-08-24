class_name QuestCluster extends Node

signal finished

@export var quest_type:QuestType
@export var tutor_home: Area2D = null
@export var objects:Array[MapObject] = []
@export var nr_of_tutorial_runs = 1
@export var nr_of_reps = 3
@export var is_last_cluster_of_level = true



enum QuestType {
	WalkTo,
	Take,
	InteractWith
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_quest: Quest = null
	var last_used_object: MapObject = null

	for i in range(nr_of_tutorial_runs):
		for obj in objects:
			var quest: Quest
			match quest_type:
				QuestType.WalkTo:
					quest = QuestWalkToNode.create(obj, true, true)
				QuestType.InteractWith:
					quest = QuestInteractWithNode.create(obj, true, true, tutor_home)
				QuestType.Take:
					quest = QuestTakeNode.create(obj, true, tutor_home)
					
			var start_condition: Condition
			if last_quest != null:
				# not using static constructor because it randomly doesn't work
				start_condition = ConditionQuestFinished.new()
				start_condition.quest_that_we_await = last_quest
			else:
				start_condition = ConditionMapStart.create()
			start_condition.delay_signal_by = 1.5
			add_child(start_condition)
			quest.start_condition = start_condition
			add_child(quest)
			last_quest = quest
			
	var objects_to_make_into_quests: Array[MapObject] = []
	for j in range(nr_of_reps):
		objects_to_make_into_quests += objects
	objects_to_make_into_quests.shuffle()
	
	for obj in objects_to_make_into_quests:
		# crudely prevent having to do the same task twice in a row
		if obj == last_used_object:
			continue
		last_used_object = obj
		var quest: Quest
		match quest_type:
			QuestType.WalkTo:
				quest = QuestWalkToNode.create(obj, false, false)
			QuestType.Take:
				# TODO: count whether that is still possible
				# after all, items vanish
				quest = QuestTakeNode.create(obj, false, tutor_home)
			QuestType.InteractWith:
				# TODO: test this mode
				quest = QuestInteractWithNode.create(obj, false, false, tutor_home)
				

		var start_condition: Condition
		if last_quest != null:
			# not using static constructor because it randomly doesn't work
			start_condition = ConditionQuestFinished.new()
			start_condition.quest_that_we_await = last_quest
		else:
			start_condition = ConditionMapStart.create()
		start_condition.delay_signal_by = 1.5
		add_child(start_condition)
		quest.start_condition = start_condition
		add_child(quest)	
		last_quest = quest
	
	if is_last_cluster_of_level:
		print("is last level")
		var end_level_condition = ConditionQuestFinishedInternal.new()
		print("last quest: ", last_quest)
		end_level_condition.quest_that_we_await = last_quest
		end_level_condition.fulfilled.connect(finish)
		add_child(end_level_condition)
						
					
func finish():
	print(name, ": finished cluster")
	finished.emit()
