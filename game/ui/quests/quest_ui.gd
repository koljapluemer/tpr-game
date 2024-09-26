class_name QuestUI extends HBoxContainer

var quest:Quest

@onready var label: Label = %Label


func set_quest_data(quest: Quest):
	label.text = quest.get_key()
	
