class_name ConditionQuestFinished extends Condition

@export var quest_that_we_await: Quest


func _ready() -> void:
	print(name, ": will call when quest finished:", quest_that_we_await)
	if quest_that_we_await:
		quest_that_we_await.finished.connect(_fulfill)
	else:
		print(name, ": no quest that we await set")

static func create(quest):
	var instance = ConditionQuestFinished.new()
	instance.quest = quest
	return instance
