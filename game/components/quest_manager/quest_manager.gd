class_name QuestManager extends Node

signal quest_started
signal quest_finished(quest:Quest)

var possible_quests:Array[Quest] = []
var current_quest:Quest

func _ready() -> void:
	MessageManager.object_was_interacted_with.connect(_on_object_was_interacted_with)
	
func _on_object_was_interacted_with(obj:ScrapbookObject, interaction: Interaction):
	if current_quest:
		if current_quest.interaction_matches_with_quest_target(obj, interaction):
			quest_finished.emit(current_quest)
			current_quest = null

func generate_possible_quests(objects:Array[ScrapbookObject]):
	possible_quests = []
	for obj:ScrapbookObject in objects:
		if not is_instance_valid(obj):
			continue
		for word in obj.word_list.words:
			for mode in obj.get_affordances():
				var quest:Quest = Quest.create(word, mode)
				possible_quests.append(quest)
				
func start_random_quest():
	var quest:Quest = possible_quests.pick_random()
	if quest:
		current_quest = quest
		quest_started.emit(quest)
