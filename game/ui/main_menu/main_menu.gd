extends Control

@onready var change_lang_button: Button = %ChangeLangButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PlayerPreferencesManager.get_pref_language_code():
		SceneManager.load_language_change_screen()
	change_lang_button.text = "(" + PlayerPreferencesManager.get_pref_language_code() + ") Change Language"

func _on_load_credits_pressed() -> void:
	SceneManager.load_credits()


func _on_change_lang_button_pressed() -> void:
	SceneManager.load_language_change_screen()

func _on_play_button_pressed() -> void:
	SceneManager.load_play_level()
