class_name InteractionButton extends Button


var interaction:Interaction

# Called when the node enters the scene tree for the first time.
func _pressed() -> void:
	GameState.current_interaction_mode = interaction
	MessageManager.interaction_mode_changed.emit(interaction)
