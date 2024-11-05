class_name AffordanceCuts extends AffordanceActive

func _ready() -> void:
	super._ready()
	Logger.log(0, "Cuts Registered ", ["CUT-KIWI"])

func _on_object_list_changed(objects:Array[ScrapbookObject]):
	# "duplicating" to a local var so that we don't temporarily
	# disable the affordance even though later in the list 
	# a suitable object exists
	var new_value_for_is_usable_in_a_quest := false
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceIsCutable:
				new_value_for_is_usable_in_a_quest = true
				break
	is_usable_in_a_quest = new_value_for_is_usable_in_a_quest
	Logger.log(1, name + " is now usable for quest: " + str(is_usable_in_a_quest), ["NEW-QUESTS", "USABLE"])

func get_verb_key() -> String:
	return "CUT"
