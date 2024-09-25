class_name QuestManager extends Node

signal quest_started

var possible_quests:Array[Quest] = []
var current_quest:Quest

func generate_possible_quests(objects:Array[ScrapbookObject]):
	possible_quests = []
	for obj:ScrapbookObject in objects:
		for word in obj.words:
			for mode in obj.get_modes():
				var quest:Quest = Quest.create(word, mode)
				possible_quests.append(quest)
				
func start_random_quest():
	var quest:Quest = possible_quests.pick_random()
	if quest:
		current_quest = quest
		quest_started.emit(quest)
