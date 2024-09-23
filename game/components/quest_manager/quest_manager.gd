class_name QuestManager extends Node

func generate_possible_quests(objects:Array[ScrapbookObject]):
	for obj:ScrapbookObject in objects:
		for mode in obj.get_modes():
			print("Possible Quest: ", obj.name, "—", mode.key)
