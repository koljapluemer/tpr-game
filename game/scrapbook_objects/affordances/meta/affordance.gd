class_name Affordance extends Node2D

var parent:ScrapbookObject

func _ready() -> void:
	parent = get_parent()
	parent.register_affordance(self)

func _report_action(active_object:ScrapbookObject, passive_object:ScrapbookObject) -> void:
	print("reporting action")
	
	var action:= Action.new()
	action.active_object = active_object
	# may be null, that's ok
	action.passive_object = passive_object
	action.verb_key = get_verb_key()
	MessageManager.action_done.emit(action)
	# log:
	Logger.log(1, str(action), ["NEW-AFFORDANCES"])


# override!
func get_verb_key() -> String:
	return "AFFORD"
