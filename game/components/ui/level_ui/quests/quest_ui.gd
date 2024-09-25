class_name QUestUI extends HBoxContainer

@onready var label: Label = %Label

func set_quest_data(quest: Quest):
	label.text = quest.get_key()
	
