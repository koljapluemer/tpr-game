## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this could
## be abstracted in the future.
class_name LevelManager extends Node2D

@export var debug_mode:= false
@export var MAX_QUESTS_PER_LEVEL := 7
@export var DELAY_UNTIL_FIRST_QUEST := 3
@export var audio_player:AudioStreamPlayer2D
const DEFINITE_ARTICLE := "THE__" 
const INDEFINITE_ARTICLE := "A__"

const SOUND_QUEST_FAILED = preload("res://game/shared_assets/paper_rip.wav")
const SOUND_SUCCESS_SHORT = preload("res://game/shared_assets/success_short.ogg")
const SOUND_WRONG_SHORT = preload("res://game/shared_assets/wrong_short.wav")

var active_quest: Quest
var quests_done:= 0
var last_quest: Quest
var currently_waiting_for_next_quest_to_start := false

var scrapbook_objects: Array[ScrapbookObject]

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var spawn_points: Node2D = %SpawnPoints


func _ready() -> void:	
	# setup of spawnpoints and quests
	if not spawn_points:
		push_error("level has no spawn_points object")
	else:
		for spawn_point:SpawnPoint in spawn_points.get_children():
			if spawn_point.has_method("spawn_in_random_object"):
				var spawned_obj := spawn_point.spawn_in_random_object()
				if spawned_obj:
					_register_scrapbook_obj(spawned_obj)
			else:
				push_warning("spawn_point is missing method")
		initial_setup(scrapbook_objects)
			
	MessageManager.object_appeared.connect(_register_scrapbook_obj)
	
	if debug_mode:
		push_warning("Debug Mode activated")
	audio_player = get_tree().get_first_node_in_group("audio_player")
	if not audio_player:
		push_warning("Level Manager has no Audio Manager")
	MessageManager.action_done.connect(_on_action_done)
	
	request_new_quest()

func _register_scrapbook_obj(obj:ScrapbookObject):
	if not obj in scrapbook_objects:
		MessageManager.object_list_changed.emit(scrapbook_objects)
		scrapbook_objects.append(obj)
		obj.hover_hint_state_changed_to.connect(_on_hover_hint_state_changed_to)


func _on_hover_hint_state_changed_to(active_obj:ScrapbookObject, passive_obj:ScrapbookObject):
	print("hover state changed: ", active_obj, passive_obj)
	for obj in scrapbook_objects:
		if is_instance_valid(obj):
			if not active_obj and not passive_obj:
			# if this is the case, there is no hover happening rn
				obj.modulate.a = 1
			else:
				# only fully show objects that are doing the hovering
				# or are primarily hovered
				if obj == active_obj or obj == passive_obj:
					obj.modulate.a = 1
				else:
					obj.modulate.a = 0.5


### ORIGINALLY FROM QUESTMANAGER ###


func initial_setup(obj_list:Array[ScrapbookObject]):
	# manually triggered by level manager after all the objects are loaded
	# from now on (but only from now on) we will dynammically listen to changes
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	_on_object_list_changed(obj_list)
	

## triggered every time a signal goes out that an [ScrapbookObject] has gone or joined from the scene tree
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	scrapbook_objects = obj_list	
	react_to_changed_object_list()
	
	
func react_to_changed_object_list():
	check_if_active_quest_is_still_possible()


func _get_possible_actions() -> Array[Action]:
	analyze_special_wording_opportunities()
	var action_list: Array[Action] = []
	for obj in scrapbook_objects:
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
	return action_list

# TODO: this is very likely completely outdated
func check_if_active_quest_is_still_possible():
	if not active_quest:
		return
	var active_quest_is_possible := false
	for action in _get_possible_actions():
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
			if action.verb_key == active_quest.required_verb and active_quest.required_passive_object_key in action.passive_object_identifiers:
				active_quest_is_possible = true
				break
		if not active_quest.required_passive_object_key:
			if action.verb_key == active_quest.required_verb and active_quest.required_active_object_key in action.active_object_identifiers:
				active_quest_is_possible = true
				break
		if action.verb_key == active_quest.required_verb and active_quest.required_active_object_key in action.active_object_identifiers and active_quest.required_passive_object_key in action.passive_object_identifiers:
				active_quest_is_possible = true
				break
			
	if not active_quest_is_possible:
		_on_quest_aborted()



func _get_possible_quest_list() -> Array[Quest]:
	analyze_special_wording_opportunities()
	# a bit of an awkward place to check whether we should just end but hey
	if quests_done >= MAX_QUESTS_PER_LEVEL:
		SceneManager.load_end_level_screen()
		return []
	
	var possible_quests:Array[Quest] = []
	for action in _get_possible_actions():
		var possible_keys_of_passive_object: Array[String] = []
		var possible_keys_of_active_object :Array[String]= action.active_object_identifiers
		
		if action.passive_object:
			possible_keys_of_passive_object = action.passive_object_identifiers
			
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
						
	return possible_quests

func request_new_quest():
	if not currently_waiting_for_next_quest_to_start and not active_quest:
		currently_waiting_for_next_quest_to_start = true
		get_tree().create_timer(1.5).timeout.connect(start_random_quest)
	else:
		print("something requested next quest, but we already have one or are waiting for one")
	


func start_random_quest():
	# prevent picking the last quest again
	var quests_that_could_be_picked: Array[Quest] = _get_possible_quest_list()
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
	for obj:ScrapbookObject in scrapbook_objects:
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
			for comparison_obj:ScrapbookObject in scrapbook_objects:
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
				for comparison_obj:ScrapbookObject in scrapbook_objects:
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
	request_new_quest()
	

func _on_quest_aborted():
	if audio_player:
		audio_player.stream = SOUND_QUEST_FAILED
		audio_player.play()
	MessageManager.quest_ended.emit(active_quest)
	
	Logger.log(1,"Erasing aborted quest")
	active_quest = null
	
	
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
		if not active_quest.required_active_object_key in action.active_object_identifiers:
			action_solved_the_quest = false
	
	if active_quest.required_passive_object_key:
		if action.passive_object:
			if not active_quest.required_passive_object_key in action.passive_object_identifiers:
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
	
	
