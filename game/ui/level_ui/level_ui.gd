## The manager for the user interface visible while playing a level
extends CanvasLayer

	#Input.set_custom_mouse_cursor(interaction_mode.cursor)

func _ready() -> void:
	MessageManager.interaction_mode_changed.connect(_on_interaction_mode_changed)

func _on_interaction_mode_changed(interaction_mode: Interaction):
	Input.set_custom_mouse_cursor(interaction_mode.cursor)


func _on_restart_button_pressed() -> void:
	SceneManager.reload_level()

func _on_end_button_pressed() -> void:
	SceneManager.load_end_level_screen()

func _on_main_menu_button_pressed() -> void:
	SceneManager.load_main_menu()
	
