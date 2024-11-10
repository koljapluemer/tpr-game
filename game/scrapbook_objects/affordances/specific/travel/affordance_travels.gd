class_name AffordanceTravels extends AffordanceActive

func _ready() -> void:
	super._ready()

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	var new_passive_objects_that_can_be_interacted_with_arr : Array[ScrapbookObject] = []
	for obj in objects:
		if is_instance_valid(obj):
			for affordance in obj.affordances:
				if affordance is AffordanceIsTravelDestination:
					new_passive_objects_that_can_be_interacted_with_arr.append(obj)
		passive_objects_that_can_be_interacted_with = new_passive_objects_that_can_be_interacted_with_arr

func get_verb_key() -> String:
	return "TRAVEL"
