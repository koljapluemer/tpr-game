class_name AffordanceIsUnlockable extends Affordance

@export var is_locked := true

@export var lock_sound: AudioStream
var audio_player:AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	audio_player = get_tree().get_first_node_in_group("audio_player")


func get_key() -> String:
	if is_locked:
		return "UNLOCK"
	else:
		return "LOCK"


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceUnlocks:
			if audio_player:
				audio_player.stream = lock_sound
				audio_player.play()
				
			_report_affordance_based_interaction()
			break


func _on_object_list_changed(objects:Array[ScrapbookObject]):
	# "duplicating" to a local var so that we don't temporarily
	# disable the affordance even though later in the list 
	# a suitable object exists
	var new_value_for_is_usable_in_a_quest := false
	for obj in objects:
		for affordance in obj.affordances:
			if affordance is AffordanceUnlocks:
				new_value_for_is_usable_in_a_quest = true
				break
	is_usable_in_a_quest = new_value_for_is_usable_in_a_quest
	Logger.log(1, name + " is now usable for quest: " + str(is_usable_in_a_quest), ["NEW-QUESTS", "USABLE"])
