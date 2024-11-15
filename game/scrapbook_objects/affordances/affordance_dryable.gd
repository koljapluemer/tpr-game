class_name AffordanceDryable extends AffordancePassive


func _ready() -> void:
	super()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceDries:
			_report_action(obj, parent)


func get_verb_key() -> String:
	return "DRY"