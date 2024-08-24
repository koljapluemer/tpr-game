class_name QuestCluster extends Node

enum QuestType {
	WalkTo,
	#Take,
	#IteractWith
}

@export var quest_type:QuestType
@export var objects:Array[MapObject] = []
@export var nr_of_tutorial_runs = 1
@export var nr_of_reps = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_quest: Quest = null
	match quest_type:
		QuestType.WalkTo:
			for i in range(nr_of_tutorial_runs):
				for obj in objects:
					var quest = QuestWalkToNode.create(obj, true, true)
					var start_condition: Condition
					if last_quest:
						start_condition = ConditionQuestFinished.create(last_quest)
					else:
						start_condition = ConditionMapStart.create()
					add_child(start_condition)
					quest.start_condition = start_condition
					add_child(quest)
			
