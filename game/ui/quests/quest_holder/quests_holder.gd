class_name QuestHolder extends VBoxContainer

@export var quest_ui:PackedScene
@export var quest_manager:QuestManager

var quest_objects: Array[QuestUI]

func _ready() -> void:
	quest_manager.quest_started.connect(add_active_quest)
	quest_manager.quest_no_longer_active.connect(remove_quest)

func add_active_quest(quest:Quest):
	var inst:QuestUI = quest_ui.instantiate()
	add_child(inst)
	if inst.has_method("set_quest_data"):
		inst.set_quest_data(quest)
		inst.quest = quest
		quest_objects.append(inst)
	else:
		push_warning(name, "set quest_ui scene does not have required method to set quest data")

func remove_quest(quest:Quest):
	for quest_obj in quest_objects:
		if quest_obj.quest == quest:
			quest_obj.queue_free()
			quest_objects.erase(quest_obj)
	
