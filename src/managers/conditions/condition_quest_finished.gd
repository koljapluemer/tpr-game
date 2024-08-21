class_name ConditionQuestFinished extends Condition

@export var quest: Quest

func _ready() -> void:
	print("quest told me that it is finished, setting connection to true")
	quest.finished.connect(_fulfill)

static func create(quest):
	var instance = ConditionQuestFinished.new()
	instance.quest = quest
	return instance
