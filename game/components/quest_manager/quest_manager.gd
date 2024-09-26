class_name QuestManager extends Node

var possible_quests:Array[Quest] = []

signal quest_started(quest:Quest)
signal quest_finished(quest:Quest)

func generate_possible_quests(objects:Array[ScrapbookObject]):
	possible_quests = []
	for obj:ScrapbookObject in objects:
		if not is_instance_valid(obj):
			continue
		for word in obj.word_list.words:
			for mode in obj.get_affordances():
				var quest:Quest = SimpleInteractionQuest.create(word, mode)
				possible_quests.append(quest)
				
func start_random_quest():
	var quest:Quest = possible_quests.pick_random()
	if quest:
		if quest.request_activation():
			quest_started.emit(quest)
			quest.finished.connect(_on_quest_finished)


func _on_quest_finished(quest:Quest):
	quest_finished.emit(quest)
	#get_tree().create_timer(0.3).connect("timeout", start_new_quest)
