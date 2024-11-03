class_name AffordanceIsCutable extends Affordance

@export var scene_to_init_when_cut:PackedScene

func _ready() -> void:
	super._ready()
	Logger.log(0, "Cutable Registered", ["CUT-KIWI"])


func get_key() -> String:
	return "CUT"


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceCuts:
			if scene_to_init_when_cut:
				var spawn_point := parent.parent_spawn_point
				MessageManager.object_disappeared.emit(parent)
				parent.queue_free()
				spawn_point.change_scene(scene_to_init_when_cut)


func _on_object_list_changed(objects:Array[ScrapbookObject]):
	# "duplicating" to a local var so that we don't temporarily
	# disable the affordance even though later in the list 
	# a suitable object exists
	var new_value_for_is_usable_in_a_quest := false
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceCuts:
				new_value_for_is_usable_in_a_quest = true
				break
	is_usable_in_a_quest = new_value_for_is_usable_in_a_quest
	Logger.log(1, name + " is now usable for quest: " + str(is_usable_in_a_quest), ["NEW-QUESTS", "USABLE"])
