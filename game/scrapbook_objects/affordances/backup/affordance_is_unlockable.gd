class_name AffordanceIsUnlockable extends AffordancePassive

@export var is_locked := true

@export var lock_sound: AudioStream
var audio_player:AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	audio_player = get_tree().get_first_node_in_group("audio_player")


func get_verb_key() -> String:
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
				
			break
