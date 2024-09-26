## An overall scaffold for a level.
## Loads a certain background and spawn points which decide
## which objects should be spawned in the end.
## Currently also does the job of a game manager, but this should
## be abstracted in the future.
extends Node2D

var interactions: Array[Interaction]
var scrapbook_objects: Array[ScrapbookObject]

func _ready() -> void:
	MessageManager.object_appeared.connect(_on_object_appeared)
	MessageManager.object_disappeared.connect(_on_object_disappeared)
	
	
func _on_object_appeared(obj:ScrapbookObject):
	scrapbook_objects.append(obj)
	MessageManager.object_list_changed.emit(scrapbook_objects)

func _on_object_disappeared(obj:ScrapbookObject):
	scrapbook_objects.erase(obj)
	print("erased object")
	MessageManager.object_list_changed.emit(scrapbook_objects)
