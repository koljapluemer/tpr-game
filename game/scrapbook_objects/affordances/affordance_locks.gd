class_name AffordanceLocks extends AffordanceActive

func _ready() -> void:
	super()


func get_verb_key() -> String:
	return "LOCK"

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	var new_passive_objects_that_can_be_interacted_with_arr : Array[ScrapbookObject] = []
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceIsLockable:
				new_passive_objects_that_can_be_interacted_with_arr.append(obj)
	passive_objects_that_can_be_interacted_with = new_passive_objects_that_can_be_interacted_with_arr
