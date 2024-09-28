class_name QuestUI extends HBoxContainer

var quest:Quest

@onready var label: Label = %Label

func set_quest_data(quest: Quest):
	print("setting text for quest: ", quest)
	var audio_path = LanguageManager.check_for_matching_audio(quest.get_key())
	var text = tr(quest.get_key())
	print("got text ", text)
	if label:
		label.text =  text
	else:
		push_warning("label not found", label)
	
