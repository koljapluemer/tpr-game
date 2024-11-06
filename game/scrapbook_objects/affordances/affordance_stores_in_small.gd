class_name AffordanceStoresInSmall extends AffordanceActive

func _ready() -> void:
	super._ready()

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	var new_passive_objects_that_can_be_interacted_with_arr : Array[ScrapbookObject] = []
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceIsSmallStorage:
				new_passive_objects_that_can_be_interacted_with_arr.append(obj)
				break
	passive_objects_that_can_be_interacted_with = new_passive_objects_that_can_be_interacted_with_arr

func get_verb_key() -> String:
	return "STORE_IN_SMALL_STORAGE"
