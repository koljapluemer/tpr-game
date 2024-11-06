class_name AffordanceIsUnlockable extends AffordancePassive

@export var unlock_sound: AudioStream
@export var scene_to_load_in_on_unlock: PackedScene
var audio_player:AudioStreamPlayer2D

func _ready() -> void:
	super._ready()
	audio_player = get_tree().get_first_node_in_group("audio_player")

func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceUnlocks:
			if audio_player:
				audio_player.stream = unlock_sound
				audio_player.play()
			_report_action(obj, parent)
			if scene_to_load_in_on_unlock:
				var spawn_point := parent.parent_spawn_point
				MessageManager.object_disappeared.emit(parent)
				parent.queue_free()
				spawn_point.change_scene(scene_to_load_in_on_unlock)


func get_verb_key() -> String:
	return "UNLOCK"
