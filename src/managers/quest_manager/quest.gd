class_name Quest extends Node2D

@export_group("Quest Settings")
@export var quest_description: String
@export var start_dialog: Dialog
@export var end_dialog: Dialog


enum QuestStatus {
	unavailable,
	available,
	started, 
	reached_goal,
	finished
}

@export var quest_status: QuestStatus = QuestStatus.available

func finish():
	pass
