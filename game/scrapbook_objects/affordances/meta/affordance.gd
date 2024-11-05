class_name Affordance extends Node2D

var parent:ScrapbookObject

func _ready() -> void:
	parent = get_parent()
	parent.register_affordance(self)


# TODO: update all the following ones
#func _report_affordance_based_interaction() -> void:
	#var action:= Action.new()
	#action.object_acted_upon = parent
	#action.used_affordance_key = get_key()
	#MessageManager.action_done.emit(action)
#
#class KeyResult:
	#var is_valid_for_quest: bool
	#var key: String
