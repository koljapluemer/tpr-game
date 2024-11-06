class_name AffordanceIsSmallStorage extends AffordancePassive


func _ready() -> void:
	super._ready()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceStoresInSmall:
			_report_action(obj, parent)
			MessageManager.object_disappeared.emit(obj)
			obj.queue_free()


func get_verb_key() -> String:
	return "STORE_IN_SMALL_STORAGE"
