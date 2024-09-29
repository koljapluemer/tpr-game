class_name QuestHolder extends VBoxContainer

@export var quest_ui:PackedScene
@export var quest_manager:QuestManager

var quest_objects: Array[Label]

func _ready() -> void:
	# TODO: decide and document whether
	# message_manager or quest_manager sends this...
	MessageManager.quest_started.connect(add_active_quest)
	quest_manager.quest_no_longer_active.connect(remove_quest)

func add_active_quest(quest:Quest):
	var inst = Label.new()
	inst.text = quest.key
	add_child(inst)
	quest_objects.append(inst)

func remove_quest(quest:Quest):
	for quest_obj in quest_objects:
		if quest_obj.text == quest.key:
			quest_obj.queue_free()
			quest_objects.erase(quest_obj)
	
