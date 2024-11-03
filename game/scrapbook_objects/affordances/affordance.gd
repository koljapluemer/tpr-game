class_name Affordance extends Node2D

var parent:ScrapbookObject



var is_usable_in_a_quest := false
# tracks whether an affordance is usable in a quest
# ...e.g is_movable_freely is always usable
# ...but is_cutable needs the "cuts" counterpart 

func _ready() -> void:
	parent = get_parent()
	parent.register_affordance(self)
	
	parent.object_dropped_on_me.connect(_on_object_dropped_on_parent)
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	

func _do_interactions_with_objects_I_was_dropped_on(areas:Array[Area2D]):
	for area in areas:
			if area is ScrapbookObject:
				area.object_dropped_on_me.emit(parent)

func _report_affordance_based_interaction() -> void:
	var action:= Action.new()
	action.object_acted_upon = parent
	action.used_affordance_key = get_key()
	MessageManager.action_done.emit(action)

class KeyResult:
	var is_valid_for_quest: bool
	var key: String

func get_key_for_quest() -> KeyResult:
	var r = KeyResult.new()
	r.is_valid_for_quest = is_usable_in_a_quest
	r.key = get_key()
	return r
	
# override!
func get_key() -> String:
	return "AFFORD"

# override if needed
func _on_object_dropped_on_parent(obj:ScrapbookObject):
	pass

# override if needed
func _on_object_list_changed(objects:Array[ScrapbookObject]):
	Logger.log(1, "override function called", ["NEW-QUESTS", "USABLE"])
	pass
