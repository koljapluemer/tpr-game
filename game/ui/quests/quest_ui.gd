class_name QuestUI extends HBoxContainer

var quest:Quest

@onready var label: Label = %Label

func set_quest_data(_quest: Quest):
	quest = _quest
	var _audio_path = LanguageManager.check_for_matching_audio(_quest.get_key())
	var text = tr(_quest.get_key())
	if label:
		label.text =  text
	else:
		push_warning("label not found", label)
	
