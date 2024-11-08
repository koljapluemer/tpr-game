class_name AffordanceIsTravelDestination extends AffordancePassive

@export var destination:Area2D

func _ready() -> void:
	super()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceTravels:
			print("something traveled here")
			_report_action(obj, parent)


func get_verb_key() -> String:
	return "TRAVEL"