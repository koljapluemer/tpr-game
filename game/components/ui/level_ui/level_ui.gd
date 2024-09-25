## The manager for the user interface visible while playing a level
extends CanvasLayer

	#Input.set_custom_mouse_cursor(interaction_mode.cursor)

func _ready() -> void:
	MessageManager.interaction_mode_changed.connect(_on_interaction_mode_changed)

func _on_interaction_mode_changed(interaction_mode: Interaction):
	print("mode changed")
	Input.set_custom_mouse_cursor(interaction_mode.cursor)
