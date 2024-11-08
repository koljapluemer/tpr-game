class_name AffordanceUnlocks extends AffordanceActive

func _ready() -> void:
	super()


func get_verb_key() -> String:
	return "UNLOCK"

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	# "duplicating" to a local var so that we don't temporarily
	# disable the affordance even though later in the list 
	# a suitable object exists
	var new_passive_objects_that_can_be_interacted_with_arr : Array[ScrapbookObject] = []
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceIsUnlockable:
				new_passive_objects_that_can_be_interacted_with_arr.append(obj)
	passive_objects_that_can_be_interacted_with = new_passive_objects_that_can_be_interacted_with_arr
