class_name QuestCluster extends Node

signal finished

@export var quest_type:QuestType
@export var objects:Array[MapObject] = []
@export var nr_of_tutorial_runs = 1
@export var nr_of_reps = 3
@export var is_last_cluster_of_level = true

enum QuestType {
	WalkTo,
	#Take,
	#IteractWith
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_quest: Quest = null
	var last_used_object: MapObject = null
	match quest_type:
		QuestType.WalkTo:
			for i in range(nr_of_tutorial_runs):
				for obj in objects:
					var quest = QuestWalkToNode.create(obj, true, true)
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
				var quest = QuestWalkToNode.create(obj, false, false)
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
