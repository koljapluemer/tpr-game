class_name QuestManager extends Node

# todo: support multiple quests
# multiple quests, and multiple *active* quests
# or let the level do that? since they're level dependent anyways...
# could make this, since it's a node, merely manage representation...hmm

@onready var quest_box: CanvasLayer = %QuestBox
@onready var quests_holder: VBoxContainer = %QuestsHolder

const QUEST_LABEL = preload("res://src/managers/quest_manager/quest_label.tscn")

var current_quests:Array[Quest] = []

func start_quest(quest):
	current_quests.append(quest)
	update_ui()
	
func update_ui():
	for child in quests_holder.get_children():
		child.queue_free()
	for quest in current_quests:
		var quest_label_obj = QUEST_LABEL.instantiate()
		quest_label_obj.text = quest.instruction
		quests_holder.add_child(quest_label_obj)
	
	
