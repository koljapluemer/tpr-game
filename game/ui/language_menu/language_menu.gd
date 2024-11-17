extends Control
@onready var language_select: OptionButton = %LanguageSelect


func _on_btn_ar_pressed() -> void:
	PlayerPreferencesManager.set_pref_language_code("ar")
	SceneManager.load_main_menu()


func _on_btn_de_pressed() -> void:
	PlayerPreferencesManager.set_pref_language_code("de")
	SceneManager.load_main_menu()
