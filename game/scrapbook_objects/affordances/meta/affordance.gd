class_name Affordance extends Node2D

var parent:ScrapbookObject
@export var can_be_used_for_quests:= true

func _ready() -> void:
	parent = get_parent()
	parent.register_affordance(self)

func _report_action(active_object:ScrapbookObject, passive_object:ScrapbookObject) -> void:

	
	var action:= Action.new()
	action.active_object = active_object
	if active_object:
		action.active_object_identifiers = active_object.get_identifiers()
	# may be null, that's ok
	action.passive_object = passive_object
	if passive_object:
		action.passive_object_identifiers = passive_object.get_identifiers()
	action.verb_key = get_verb_key()
	MessageManager.action_done.emit(action)
	# log:
	Logger.log(1, str(action), ["NEW-AFFORDANCES"])


# override!
func get_verb_key() -> String:
	return "AFFORD"
