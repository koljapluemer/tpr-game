## Handles identifying possible quests, which quests to do next, and by which id to call words
class_name QuestManager extends Node

signal quest_no_longer_active(quest:Quest)

@export var debug_mode:= true
@export var MAX_QUESTS_PER_LEVEL := 7
@export var DELAY_UNTIL_FIRST_QUEST := 3
@export var assume_there_is_a_grid:= false
@export var audio_player:AudioStreamPlayer2D


const DEFINITE_ARTICLE := "THE__" 
const INDEFINITE_ARTICLE := "A__"

const SOUND_QUEST_FAILED = preload("res://game/shared_assets/paper_rip.wav")
const SOUND_SUCCESS_SHORT = preload("res://game/shared_assets/success_short.ogg")
const SOUND_WRONG_SHORT = preload("res://game/shared_assets/wrong_short.wav")

# this exact same thing is also tracked in `level_template.gd`
# it is basically synced here via signal. I'm not if that's bad.
# ...would be smarter to only get it when needed
# but then again, I also need to react when quests become impossible...
var objects: Array[ScrapbookObject] = []
var active_quests: Array[Quest] = []
var possible_quests: Array[Quest] = []
var quests_done:= 0
var last_quest: Quest
var currently_waiting_for_next_quest_to_start := false


func _ready() -> void:
	if debug_mode:
		push_warning("Debug Mode activated")
	if not audio_player:
		push_warning("Quest Manager has no Audio Manager")
	MessageManager.register_unproductive_action.connect(_on_unproductive_action_registered)

func initial_setup(obj_list:Array[ScrapbookObject]):
	# manually triggered by level manager after all the objects are loaded
	# from now on (but only from now on) we will dynammically listen to changes
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	_on_object_list_changed(obj_list)
	

## triggered every time a signal goes out that an [ScrapbookObject] has gone or joined from the scene tree
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	objects = obj_list	
	Logger.log(0, "reacting to changed obj list, which now has len " + str(len(objects)), ["NEW-QUESTS"])
	react_to_changed_object_list()
	
	
func react_to_changed_object_list():
	analyze_special_wording_opportunities()
	check_if_active_quests_are_still_possible()
	if not currently_waiting_for_next_quest_to_start:
		currently_waiting_for_next_quest_to_start = true
		make_sure_that_there_is_one_active_quest()

func check_if_active_quests_are_still_possible():
	Logger.log(1,"check_if_active_quests_are_still_possible()")
	if len(active_quests) == 0:
		return
	# get all the words currently available
	var available_words: Array[String] = []
	for obj in objects:
		available_words.append_array(obj.sensible_identifiers)
	
	Logger.log(1,"nr of active quests:" + str(len(active_quests)))
	for quest in active_quests:
		Logger.log(1,"checkin quest: " + str(quest))
		var quest_is_possible = true
		for word in quest.required_words:
			Logger.log(1,"checking word: " + word)
			if not available_words.has(word):
				quest_is_possible = false
				break
		if not quest_is_possible:
			quest.set_aborted()
				

func make_sure_that_there_is_one_active_quest():	
	if len(active_quests) == 0:
		update_possible_quest_list()
		start_random_quest()
	currently_waiting_for_next_quest_to_start = false
		
		
# TODO: this is triggered before all spawnpoitns
# have communicated their objects and potentials
# so the first quest is always related to the first object
# spawned and cannot involve interactions
func update_possible_quest_list() -> void:
	# a bit of an awkward place to check whether we should just end but hey
	if quests_done >= MAX_QUESTS_PER_LEVEL:
		SceneManager.load_end_level_screen()
		return
	
	possible_quests = []
	for object:ScrapbookObject in objects:
		Logger.log(0, "checking obj for quests", ["NEW-QUESTS"])
		var keys = object.get_possible_quest_keys()
		Logger.log(0, str(keys), ["NEW-QUESTS"])
		
	return 

func start_random_quest():
	# prevent picking the last quest again
	var quests_that_could_be_picked: Array[Quest] = possible_quests
	if last_quest:
		for q:Quest in quests_that_could_be_picked:
			if last_quest.key == q.key:
				quests_that_could_be_picked.erase(q)
	if len(quests_that_could_be_picked) > 0:
		var quest:Quest = quests_that_could_be_picked.pick_random()
				
		if quest.request_activation():
			MessageManager.quest_started.emit(quest)
			quest.finished.connect(_on_quest_finished)
			quest.aborted.connect(_on_quest_aborted)
			active_quests.append(quest)
			Logger.log(1,"appended quest, active_quests now contains nr: " + str(len(active_quests)))
			last_quest = quest
	else:
		if not debug_mode:
			SceneManager.load_end_level_screen()



## checking for things like "go to the left bus"
func analyze_special_wording_opportunities():
	for obj:ScrapbookObject in objects:
		var sensible_identifiers:Array[String] = []
		if not is_instance_valid(obj):
			push_warning("warning: attempting to analyze begone object", obj)
			continue
		# find objects that have the same word
		# (to find out whether or not to use definite article)
		for word in obj.word_list:
			var object_is_the_only_one_using_this_word:= true
			for comparison_obj:ScrapbookObject in objects:
				if not comparison_obj == obj and is_instance_valid(comparison_obj):
					if comparison_obj.word_list.has(word):
						object_is_the_only_one_using_this_word = false
			if object_is_the_only_one_using_this_word:
				sensible_identifiers.append(DEFINITE_ARTICLE+ word)
			else:
				sensible_identifiers.append(INDEFINITE_ARTICLE+ word)
		
		# find objects that have the same word, but different color
		if obj.color != "":
			for word in obj.word_list:
				var color_count = {}
				for comparison_obj:ScrapbookObject in objects:
					if comparison_obj.word_list.has(word):
						if color_count.has(comparison_obj.color):
							color_count[comparison_obj.color] += 1
						else:
							color_count[comparison_obj.color] = 1
				if len(color_count) > 1:
					if color_count[obj.color] == 1:
						# the object, with this word, is the only one with this color
						sensible_identifiers.append(DEFINITE_ARTICLE+ word + "__" + obj.color)
					else:
						# the object, with this word, is one of several with this color
						sensible_identifiers.append(INDEFINITE_ARTICLE + word + "__" + obj.color)
		
		# find objects in the same column
		# TODO: this breaks when objects in the same column also have the same row
		# TODO: there is also no check for the default case of objects just chilling on (0, 0)
		# maybe move the default to something like -99 or have a toggle?
		if assume_there_is_a_grid:
			for word in obj.word_list:
				var min_row_value:int= 100000
				var max_row_value:int= -100000
				var objects_on_same_column:Array[ScrapbookObject] = []
				for comparison_obj:ScrapbookObject in objects:
					if comparison_obj.grid_pos.x == obj.grid_pos.x:
						if comparison_obj.word_list.has(word):
							objects_on_same_column.append(comparison_obj)
							if comparison_obj.grid_pos.y < min_row_value:
								min_row_value = comparison_obj.grid_pos.y
							if comparison_obj.grid_pos.y > max_row_value:
								max_row_value = comparison_obj.grid_pos.y
				
				# in front, in the middle, in the back
				if len(objects_on_same_column) == 3:
					if obj.grid_pos.y == min_row_value:
						sensible_identifiers.append(DEFINITE_ARTICLE + word + "__AT_FRONT")
					elif obj.grid_pos.y == max_row_value:
						sensible_identifiers.append(DEFINITE_ARTICLE + word + "__AT_BACK")
					else:
						sensible_identifiers.append(DEFINITE_ARTICLE + word + "__IN_MIDDLE")
		
		# crudely filter for unique values
		obj.sensible_identifiers = []
		for id in sensible_identifiers:
			if not obj.sensible_identifiers.has(id):
				obj.sensible_identifiers.append(id)


func _on_quest_finished(quest:Quest):
	Logger.log(1,"QM: quest finished..." + str(quest))
	if audio_player:
		Logger.log(1,"playing audio")
		audio_player.stream = SOUND_SUCCESS_SHORT
		audio_player.play()
	quest_no_longer_active.emit(quest)
	active_quests.erase(quest)
	quests_done += 1
	react_to_changed_object_list()


func _on_quest_aborted(quest:Quest):
	if audio_player:
		audio_player.stream = SOUND_QUEST_FAILED
		audio_player.play()
	quest_no_longer_active.emit(quest)
	Logger.log(1,"Erasing aborted quest")
	active_quests.erase(quest)
	react_to_changed_object_list()
	
## react to actions not fulfilling a quest goal
func _on_unproductive_action_registered():
	if audio_player:
		audio_player.stream = SOUND_WRONG_SHORT
		audio_player.play()
