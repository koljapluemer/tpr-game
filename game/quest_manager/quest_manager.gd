## Handles identifying possible quests, which quests to do next, and by which id to call words
class_name QuestManager extends Node


@export var debug_mode:= false
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
var active_quest: Quest
var possible_quests: Array[Quest] = []
var quests_done:= 0
var last_quest: Quest
var currently_waiting_for_next_quest_to_start := false

var possible_actions: Array[Action] = []

func _ready() -> void:
	if debug_mode:
		push_warning("Debug Mode activated")
	if not audio_player:
		push_warning("Quest Manager has no Audio Manager")
	MessageManager.action_done.connect(_on_action_done)

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
	update_possible_actions()
	check_if_active_quest_is_still_possible()
	
	if not currently_waiting_for_next_quest_to_start:
		currently_waiting_for_next_quest_to_start = true
		make_sure_that_there_is_an_active_quest()

func update_possible_actions():
	analyze_special_wording_opportunities()
	var action_list: Array[Action] = []
	for obj in objects:
		if not is_instance_valid(obj):
			continue
		for affordance in obj.affordances:
			if affordance is AffordanceActive:
				var possible_partners = affordance.get_possible_passive_objects_that_affordance_can_interact_with()
				for partner in possible_partners:
					var action := Action.new()
					action.active_object = obj
					action.passive_object = partner
					action.verb_key = affordance.get_verb_key()
					action_list.append(action)
	possible_actions = action_list

# TODO: this is very likely completely outdated
func check_if_active_quest_is_still_possible():
	if not active_quest:
		return
	var active_quest_is_possible := false
	for action in possible_actions:
		# check separately: 
		# quests that only require a verb.
		# quests that require a verb and an active object,
		# quests that require a verb and a passive object,
		# quests that require all three
		if not active_quest.required_active_object_key and not active_quest.required_passive_object_key:
			if action.verb_key == active_quest.required_verb:
				active_quest_is_possible = true
				break
		if not active_quest.required_active_object_key:
			if action.verb_key == active_quest.required_verb and active_quest.required_passive_object_key in action.passive_object.get_identifiers():
				active_quest_is_possible = true
				break
		if not active_quest.required_passive_object_key:
			if action.verb_key == active_quest.required_verb and active_quest.required_active_object_key in action.active_object.get_identifiers():
				active_quest_is_possible = true
				break
		if action.verb_key == active_quest.required_verb and active_quest.required_active_object_key in action.active_object.get_identifiers() and active_quest.required_passive_object_key in action.passive_object.get_identifiers():
				active_quest_is_possible = true
				break
			
	if not active_quest_is_possible:
		_on_quest_aborted()



func make_sure_that_there_is_an_active_quest():	
	if not active_quest:
		update_possible_quest_list()
		start_random_quest()
	currently_waiting_for_next_quest_to_start = false
		
		
# TODO: this is triggered before all spawnpoitns
# have communicated their objects and potentials
# so the first quest is always related to the first object
# spawned and cannot involve interactions
func update_possible_quest_list() -> void:
	analyze_special_wording_opportunities()
	# a bit of an awkward place to check whether we should just end but hey
	if quests_done >= MAX_QUESTS_PER_LEVEL:
		LanguageLearningDataManager.earn_star_for_topic(SceneManager.current_topic)
		SceneManager.load_end_level_screen()
		return
	
	possible_quests = []
	for action in possible_actions:
		var possible_keys_of_passive_object: Array[String] = []
		var possible_keys_of_active_object :Array[String]= action.active_object.get_identifiers()
		
		if action.passive_object:
			possible_keys_of_passive_object = action.passive_object.get_identifiers()
			
			# ex: ANY__CUT__ANY
			var any_any_quest = Quest.new()
			any_any_quest.required_verb = action.verb_key
			if LanguageManager.check_for_matching_audio(str(any_any_quest)):
				possible_quests.append(any_any_quest)
				
			for active_key in possible_keys_of_active_object:
				# ex: THE__KNIFE__CUT__ANY	
				var active_to_any_quest = Quest.new()
				active_to_any_quest.required_active_object_key = active_key
				active_to_any_quest.required_verb = action.verb_key
				if LanguageManager.check_for_matching_audio(str(active_to_any_quest)):
						possible_quests.append(active_to_any_quest)

				
			for passive_key in possible_keys_of_passive_object:
				# ex: ANY__CUT__THE__KIWI
				var q = Quest.new()
				q.required_passive_object_key = passive_key
				q.required_verb = action.verb_key
				if LanguageManager.check_for_matching_audio(str(q)):
					possible_quests.append(q)
				for active_key in possible_keys_of_active_object:
					# ex: THE__KNIFE__CUT__THE__KIWI	
					var qu = Quest.new()
					qu.required_active_object_key = active_key
					qu.required_passive_object_key = passive_key
					qu.required_verb = action.verb_key
					if LanguageManager.check_for_matching_audio(str(qu)):
						print("q:", str(qu))
						possible_quests.append(qu)
		else:
			for active_key in possible_keys_of_active_object:
				# ex: THE__KNIFE__MOVE	
				var active_to_any_quest = Quest.new()
				active_to_any_quest.required_active_object_key = active_key
				active_to_any_quest.required_verb = action.verb_key
				if LanguageManager.check_for_matching_audio(str(active_to_any_quest)):
						possible_quests.append(active_to_any_quest)


func start_random_quest():
	# prevent picking the last quest again
	var quests_that_could_be_picked: Array[Quest] = possible_quests
	if last_quest:
		for q:Quest in quests_that_could_be_picked:
			if str(last_quest) == str(q):
				quests_that_could_be_picked.erase(q)
	if len(quests_that_could_be_picked) > 0:
		var quest:Quest = quests_that_could_be_picked.pick_random()
		MessageManager.quest_started.emit(quest)
		active_quest = quest
		last_quest = quest
		
		LanguageManager.play_audio_for_key(str(quest))
	else:
		if not debug_mode:
			SceneManager.load_end_level_screen()


## checking for things like "go to the left bus"
func analyze_special_wording_opportunities():
	for obj:ScrapbookObject in objects:
		if not is_instance_valid(obj):
			continue
		var ids:Array[String] = []
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
				ids.append(DEFINITE_ARTICLE+ word)
			else:
				ids.append(INDEFINITE_ARTICLE+ word)
		
		# find objects that have the same word, but different color
		if obj.color != "":
			for word in obj.word_list:
				var color_count = {}
				for comparison_obj:ScrapbookObject in objects:
					if not is_instance_valid(comparison_obj):
						continue
					if comparison_obj.word_list.has(word):
						if color_count.has(comparison_obj.color):
							color_count[comparison_obj.color] += 1
						else:
							color_count[comparison_obj.color] = 1
				if len(color_count) > 1:
					if color_count[obj.color] == 1:
						# the object, with this word, is the only one with this color
						ids.append(DEFINITE_ARTICLE+ word + "__" + obj.color)
					else:
						# the object, with this word, is one of several with this color
						ids.append(INDEFINITE_ARTICLE + word + "__" + obj.color)
		
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
						ids.append(DEFINITE_ARTICLE + word + "__AT_FRONT")
					elif obj.grid_pos.y == max_row_value:
						ids.append(DEFINITE_ARTICLE + word + "__AT_BACK")
					else:
						ids.append(DEFINITE_ARTICLE + word + "__IN_MIDDLE")
		
		# crudely filter for unique values
		obj.sensible_identifiers = []
		for id in ids:
			if not obj.sensible_identifiers.has(id):
				obj.sensible_identifiers.append(id)


func _on_quest_finished():
	if audio_player:
		Logger.log(1,"playing audio")
		audio_player.stream = SOUND_SUCCESS_SHORT
		audio_player.play()
	MessageManager.quest_ended.emit(active_quest)
	active_quest = null
	quests_done += 1
	get_tree().create_timer(1.5).timeout.connect(react_to_changed_object_list)

func _on_quest_aborted():
	if audio_player:
		audio_player.stream = SOUND_QUEST_FAILED
		audio_player.play()
	MessageManager.quest_ended.emit(active_quest)
	
	Logger.log(1,"Erasing aborted quest")
	active_quest = null
	react_to_changed_object_list()
	
## react to actions not fulfilling a quest goal
func _on_unproductive_action_registered():
	if audio_player:
		audio_player.stream = SOUND_WRONG_SHORT
		audio_player.play()

func _on_action_done(action:Action):
	# if action happened while we were currently waiting for a quest
	# we simply don't look at it
	if not active_quest:
		return
		
	var action_solved_the_quest := true
	# check for active, passive and verb, dependent on whether that property was set in the quest
	# if it wasn't set, it wasn't relevant, and we don't check for it
	if active_quest.required_active_object_key:
		# actions always come with an active object, even if it's not relevant
		if not active_quest.required_active_object_key in action.active_object.get_identifiers():
			action_solved_the_quest = false
	
	if active_quest.required_passive_object_key:
		if action.passive_object:
			if not active_quest.required_passive_object_key in action.passive_object.get_identifiers():
				action_solved_the_quest = false
		else:
			action_solved_the_quest = false
	
	# verb is always set	
	if not active_quest.required_verb == action.verb_key:
		action_solved_the_quest = false
	
	if action_solved_the_quest:
		_on_quest_finished()
	else:
		_on_unproductive_action_registered()
	
	
			
		
