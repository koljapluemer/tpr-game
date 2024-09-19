class_name EventQuestStart extends Event

@export var quest:Quest

static func create(quest):
	var instance = EventQuestStart.new()
	instance.quest = quest
	return instance

func _ready() -> void:
	super()
	
func _run():
	Globals.quest_mngr.start_quest(self)

	
