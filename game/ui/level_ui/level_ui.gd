## The manager for the user interface visible while playing a level
extends CanvasLayer

@onready var popup: Popup = %Popup


func _on_restart_button_pressed() -> void:
	SceneManager.reload_level()

func _on_end_button_pressed() -> void:
	SceneManager.load_end_level_screen()

func _on_main_menu_button_pressed() -> void:
	SceneManager.load_main_menu()
	


func _on_menu_button_pressed() -> void:
	popup.visible = true
