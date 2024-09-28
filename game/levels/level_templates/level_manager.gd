## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this could
## be abstracted in the future.
class_name LevelManager extends Node2D

var interactions: Array[Interaction]
var scrapbook_objects: Array[ScrapbookObject]

# drag and drop
var currently_dragged_object: ScrapbookObject

func _ready() -> void:
	get_parent().get_viewport().set_physics_object_picking_sort(true)
	
	MessageManager.object_appeared.connect(_on_object_appeared)
	MessageManager.object_disappeared.connect(_on_object_disappeared)
	
	# Drag and Drop
	MessageManager.object_drag_started.connect(_on_object_drag_started)
	MessageManager.object_drag_finished.connect(_on_object_drag_finished)
	
func _on_object_appeared(obj:ScrapbookObject):
	scrapbook_objects.append(obj)
	MessageManager.object_list_changed.emit(scrapbook_objects)

func _on_object_disappeared(obj:ScrapbookObject):
	scrapbook_objects.erase(obj)
	MessageManager.object_list_changed.emit(scrapbook_objects)

## Drag and Drop
func _on_object_drag_started(obj: ScrapbookObject):
	print("registered drag of", obj)
	currently_dragged_object = obj
	_find_and_mark_eligible_objects_to_drop_on()
	
func _on_object_drag_finished(obj: ScrapbookObject):
	currently_dragged_object = null
	pass

## this function is triggered when a drag (on a [property is_movable] [ScrapbookObject]) was started
## we then want to go through all [ScrapbookObject]s that are in the scene
## for each, we check if it offers [ScrapbookInteraction]s whose keyword matches any of the words of the thing
## we're dragging.
## If so, we highlight them.
func _find_and_mark_eligible_objects_to_drop_on():
	if not currently_dragged_object:
		return 
		
	for obj in scrapbook_objects:
		# don't check for self-interaction
		if obj == currently_dragged_object:
			continue
		for scrapbook_interaction in obj.scrapbook_interactions:
			if currently_dragged_object.word_list.words.has(scrapbook_interaction.key_word):
				obj.set_highlighted()
