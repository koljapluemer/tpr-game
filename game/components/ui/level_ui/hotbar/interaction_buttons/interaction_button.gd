class_name InteractionButton extends Button

signal interaction_mode_requested

var interaction:Interaction

# Called when the node enters the scene tree for the first time.
func _pressed() -> void:
	interaction_mode_requested.emit(interaction)
