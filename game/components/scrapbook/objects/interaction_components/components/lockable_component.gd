## An [InteractionComponent] allowing an object to be locked and unlocked.
class_name LockableComponent extends InteractionComponent

signal object_lock_status_toggled

@export var audio_player:AudioStreamPlayer2D
@export var lock_sound: AudioStream
@export_category("State")
@export var locked = true


func _react_to_input():
	object_lock_status_toggled.emit()
	if audio_player and lock_sound:
		audio_player.stream = lock_sound
		audio_player.play()
	locked = !locked
