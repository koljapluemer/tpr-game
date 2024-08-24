class_name QuestCluster extends Node

enum QuestType {
	WalkTo,
	#Take,
	#IteractWith
}

@export var quest_type:QuestType
@export var objects:Array[MapObject] = []
@export var nr_of_tutorial_runs = 1
@export var nr_of_reps = 3

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
				# not using static constructor because it randomly doesn't work
				var start_condition = ConditionQuestFinished.new()
				start_condition.quest_that_we_await = last_quest
				start_condition.delay_signal_by = 1.5
				add_child(start_condition)
				quest.start_condition = start_condition
				add_child(quest)	
				last_quest = quest
						
					
			
