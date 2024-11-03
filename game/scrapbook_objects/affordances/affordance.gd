class_name Affordance extends Node2D

var parent:ScrapbookObject

class KeyResult:
	var is_valid_for_quest: bool
	var key: String

# override!
func get_key_for_quest() -> KeyResult:
	var r = KeyResult.new()
	r.is_valid_for_quest = false
	r.key = ""
	return r

func _ready() -> void:
	parent = get_parent()
	parent.register_affordance(self)
	parent.object_dropped_on_me.connect(_on_object_dropped_on_parent)
	
func _do_interactions_with_objects_I_was_dropped_on(areas:Array[Area2D]):
	for area in areas:
			if area is ScrapbookObject:
				area.object_dropped_on_me.emit(parent)

# overwrite
func _on_object_dropped_on_parent(obj:ScrapbookObject):
	pass
