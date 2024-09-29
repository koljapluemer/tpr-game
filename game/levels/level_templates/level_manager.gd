## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this could
## be abstracted in the future.
class_name LevelManager extends Node2D

@export_multiline var learning_goal:String ## internal documentation

var interactions: Array[Interaction]
var scrapbook_objects: Array[ScrapbookObject]

var objects_currently_hovered_by_mouse: Array[ScrapbookObject]
var object_intended_to_be_hovered_by_mouse: ScrapbookObject

var background:Area2D
# drag and drop
var currently_dragged_object: ScrapbookObject
var currently_hovered_obj: ScrapbookObject

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D


func _ready() -> void:
	get_parent().get_viewport().set_physics_object_picking_sort(false)
	
	MessageManager.object_appeared.connect(_on_object_appeared)
	MessageManager.object_disappeared.connect(_on_object_disappeared)
	
	# Drag and Drop
	MessageManager.object_drag_started.connect(_on_object_drag_started)
	MessageManager.object_drag_finished.connect(_on_object_drag_finished)
	
	# Mouse Over
	# background catch
	background = get_tree().get_first_node_in_group("background")
	if background:
		# TODO: this check is here to prevent a race condition when a new scene is loaded
		# which is pretty bad, because that means in the next level bg is likely
		# never connected
		background.mouse_entered.connect(_on_bg_mouse_over_started)
	MessageManager.object_mouse_over_started.connect(_on_object_mouse_over_started)
	MessageManager.object_mouse_over_started.connect(_on_object_mouse_over_finished)
	# quest listening (for audio)
	MessageManager.quest_started.connect(_on_quest_started)
	
func _on_bg_mouse_over_started():
	if currently_hovered_obj:
		currently_hovered_obj.set_interactable()
		currently_hovered_obj =  null
	
func _on_object_appeared(obj:ScrapbookObject):
	scrapbook_objects.append(obj)
	MessageManager.object_list_changed.emit(scrapbook_objects)

func _on_object_disappeared(obj:ScrapbookObject):
	scrapbook_objects.erase(obj)
	MessageManager.object_list_changed.emit(scrapbook_objects)

## Drag and Drop
func _on_object_drag_started(obj: ScrapbookObject):
	currently_dragged_object = obj
	_find_and_mark_eligible_objects_to_drop_on()
	
func _on_object_drag_finished(_obj: ScrapbookObject):
	currently_dragged_object = null
	if is_instance_valid(currently_hovered_obj):
		currently_hovered_obj.drop_other_obj_on_this_obj(_obj)

## this function is triggered when a drag (on a [property is_movable] [ScrapbookObject]) was started
## we then want to go through all [ScrapbookObject]s that are in the scene
## for each, we check if it offers [ScrapbookInteraction]s whose keyword matches any of the words of the thing
## we're dragging.
## If so, we highlight them.
func _find_and_mark_eligible_objects_to_drop_on():
	if not currently_dragged_object or not is_instance_valid(currently_dragged_object):
		return 
		
	for obj in scrapbook_objects:
		if not is_instance_valid(obj):
			continue
		# don't check for self-interaction
		if obj == currently_dragged_object:
			continue
		for scrapbook_interaction in obj.scrapbook_interactions:
			if currently_dragged_object.word_list.has(scrapbook_interaction.key_word):
				obj.set_highlighted()
				
# finding the actual intended mouse hover stuff
func _on_object_mouse_over_started(obj:ScrapbookObject):
	#objects_currently_hovered_by_mouse.append(obj)
	if currently_hovered_obj and is_instance_valid(currently_hovered_obj):
		currently_hovered_obj.set_interactable()
	currently_hovered_obj = obj
	obj.react_to_being_hovered()
	
func _on_object_mouse_over_finished(_obj:ScrapbookObject):
	pass
	

func _on_quest_started(quest: Quest):
	if audio_stream_player_2d:
		var audio = "res://game/language/translation_audio/" + TranslationServer.get_locale() + "/" + quest.key + ".mp3"
		if ResourceLoader.exists(audio):
			audio_stream_player_2d.stream = load(audio)
			audio_stream_player_2d.play()
		else:
			print("audio does not exist:", audio)
	else:
		push_warning(("audio_player not found")
