class_name QuestManager extends Node

@export var quest_ui:Container

const LEVEL_UI_QUEST = preload("res://game/components/ui/level_ui/quests/level_ui_quest.tscn")

var possible_quests

func generate_possible_quests(objects:Array[ScrapbookObject]):
	for obj:ScrapbookObject in objects:
		for word in obj.words:
			for mode in obj.get_modes():
				print("Possible Quest: ", word.key, "—", mode.key)
