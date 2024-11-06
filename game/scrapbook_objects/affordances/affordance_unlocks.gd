class_name AffordanceUnlocks extends AffordanceActive

func _ready() -> void:
	super._ready()


func get_verb_key() -> String:
	# TODO: shit, this may need to be complicated based on receiver...
	return "LOCK-UNLOCK"

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	# "duplicating" to a local var so that we don't temporarily
	# disable the affordance even though later in the list 
	# a suitable object exists
	var new_value_for_is_usable_in_a_quest := false
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceIsUnlockable:
				new_value_for_is_usable_in_a_quest = true
				break
