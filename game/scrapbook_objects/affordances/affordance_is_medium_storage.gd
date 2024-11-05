class_name AffordanceIsMediumStorage extends AffordancePassive


func _ready() -> void:
	super._ready()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceStoresInMedium:
			_report_action(obj, parent)


func get_verb_key() -> String:
	return "STORE_IN_MEDIUM_STORAGE"
