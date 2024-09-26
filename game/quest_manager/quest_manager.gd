class_name QuestManager extends Node

signal quest_started(quest:Quest)
signal quest_no_longer_active(quest:Quest)

@export var MAX_QUESTS_PER_LEVEL := 5

# this exact same thing is also tracked in `level_template.gd`
# it is basically synced here via signal. I'm not if that's bad.
# ...would be smarter to only get it when needed
# but then again, I also need to react when quests become impossible...
var objects: Array[ScrapbookObject] = []
var active_quests: Array[Quest] = []
var quests_done:= 0

func _ready() -> void:
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	objects = obj_list
	if len(active_quests) > 0:
		check_if_active_quests_are_still_possible()
	make_sure_that_there_is_one_active_quest()

func check_if_active_quests_are_still_possible():
	# get all the words currently available
	var available_words: Array[Word] = []
	for obj in objects:
		available_words.append_array(obj.word_list.words)
	
	for quest in active_quests:
		var quest_is_possible = true
		for word in quest.required_words:
			if not available_words.has(word):
				quest_is_possible = false
				break
		if not quest_is_possible:
			quest.set_aborted()
				

func make_sure_that_there_is_one_active_quest():	
	if len(active_quests) == 0:
		start_random_quest()
		
# TODO: this is triggered before all spawnpoitns
# have communicated their objects and potentials
# so the first quest is always related to the first object
# spawned and cannot involve interactions
func start_random_quest():
	# a bit of an awkward place to check whether we should just end but hey
	if quests_done >= MAX_QUESTS_PER_LEVEL:
		SceneManager.load_end_level_screen()
		return
	
	var possible_quests = []

	# TODO: we're getting the words of objects here *a lot* of times
	for obj:ScrapbookObject in objects:
		for word in obj.word_list.words:
			for mode in obj.get_affordances():
				var quest:Quest = SimpleInteractionQuest.create(word, mode)
				possible_quests.append(quest)
		# TODO: build combination quests :)
		# loop through the objects again, and see if
		# any one satisfies the one this one wants to combine with
		# aka fruit x is ready to be combined with any knife
		# well, is there any word tagged knife?
		for possible_combination_object in objects:
			if not possible_combination_object == obj:
				# skip the object we're already looking at
				# we can't combine objects with themselves
				for scrapbook_interaction:ScrapbookInteraction in obj.scrapbook_interactions:
					if possible_combination_object.word_list.words.has(scrapbook_interaction.key_word):
						var word_to_call_receiving_object:Word = obj.word_list.words.pick_random()
						var word_to_call_sending_object: Word = scrapbook_interaction.key_word
						var quest = CombineTwoObjectsQuest.create(word_to_call_sending_object, word_to_call_receiving_object)
						possible_quests.append(quest)
	
	var quest:Quest = possible_quests.pick_random()
	if quest:
		if quest.request_activation():
			quest_started.emit(quest)
			quest.finished.connect(_on_quest_finished)
			quest.aborted.connect(_on_quest_aborted)
			active_quests.append(quest)
	else:
		# if we don't have quests, means stuff like 
		# all objects were taken
		SceneManager.load_end_level_screen()


func _on_quest_finished(quest:Quest):
	quest_no_longer_active.emit(quest)
	active_quests.erase(quest)
	quests_done += 1
	# TODO: this in theory can create impossible quests
	# ...which is currently stopped because of the long wait :D
	get_tree().create_timer(1).connect("timeout", make_sure_that_there_is_one_active_quest)

func _on_quest_aborted(quest:Quest):
	quest_no_longer_active.emit(quest)
	active_quests.erase(quest)
