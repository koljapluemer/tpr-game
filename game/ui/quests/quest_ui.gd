class_name QuestUI extends HBoxContainer

var quest:Quest

@onready var label: Label = %Label


func set_quest_data(quest: Quest):
	var audio_path = LanguageManager.check_for_matching_audio(quest.get_key())
	label.text = tr(quest.get_key())
	
