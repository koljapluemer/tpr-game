extends Button

var active_quest:Quest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MessageManager.quest_started.connect(_on_quest_started)
	MessageManager.quest_ended.connect(_on_quest_ended)


func _on_quest_started(quest:Quest):
	active_quest = quest
	
func _on_quest_ended(quest:Quest):
	active_quest = null


func _on_pressed() -> void:
	if active_quest:
		LanguageManager.play_audio_for_key(str(active_quest))
