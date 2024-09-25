class_name QuestHolder extends VBoxContainer

@export var quest_ui:PackedScene
@export var quest_manager:QuestManager

func _ready() -> void:
	quest_manager.quest_started.connect(add_active_quest)

func add_active_quest(quest:Quest):
	var inst = quest_ui.instantiate()
	add_child(inst)
	if inst.has_method("set_quest_data"):
		inst.set_quest_data(quest)
	else:
		push_warning(name, "set quest_ui scene does not have required method to set quest data")
