class_name AffordanceHasTravelDestination extends AffordancePassive

@export var destination:Area2D

func _ready() -> void:
	super()



func _on_object_dropped(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceTravels:
			_report_action(obj, parent)
			MessageManager.object_disappeared.emit(obj)
			obj.queue_free()


func get_verb_key() -> String:
	return "TRAVEL"
