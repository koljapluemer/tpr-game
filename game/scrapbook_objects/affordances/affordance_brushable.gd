class_name AffordanceBrushable extends AffordancePassive


func _ready() -> void:
	super._ready()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceBrushes:
			_report_action(obj, parent)


func get_verb_key() -> String:
	return "BRUSH"
