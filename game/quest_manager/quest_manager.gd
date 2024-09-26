class_name QuestManager extends Node

signal quest_started(quest:Quest)
signal quest_finished(quest:Quest)


# this exact same thing is also tracked in `level_template.gd`
# it is basically synced here via signal. I'm not if that's bad.
# ...would be smarter to only get it when needed
# but then again, I also need to react when quests become impossible...
var objects: Array[ScrapbookObject] = []
var active_quests: Array[Quest] = []

func _ready() -> void:
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	objects = obj_list
	make_sure_that_there_is_one_active_quest()


func make_sure_that_there_is_one_active_quest():	
	if len(active_quests) == 0:
		start_random_quest()
		
func start_random_quest():
	var possible_quests = []
	for obj:ScrapbookObject in objects:
		for word in obj.word_list.words:
			for mode in obj.get_affordances():
				var quest:Quest = SimpleInteractionQuest.create(word, mode)
				possible_quests.append(quest)
	
	print("possible quests: ", possible_quests)
	
	var quest:Quest = possible_quests.pick_random()
	if quest:
		if quest.request_activation():
			quest_started.emit(quest)
			quest.finished.connect(_on_quest_finished)
			active_quests.append(quest)
	else:
		# if we don't have quests, means stuff like 
		# all objects were taken
		SceneManager.load_end_level_screen()


func _on_quest_finished(quest:Quest):
	quest_finished.emit(quest)
	active_quests.erase(quest)
	# TODO: this in theory can create impossible quests
	# ...which is currently stopped because of the long wait :D
	get_tree().create_timer(1).connect("timeout", make_sure_that_there_is_one_active_quest)
