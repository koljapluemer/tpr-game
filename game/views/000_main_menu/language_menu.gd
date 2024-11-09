extends Control
@onready var language_select: OptionButton = %LanguageSelect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if TranslationServer.get_locale() == "ar":
		language_select.selected = 0

	if TranslationServer.get_locale() == "de":
		language_select.selected = 1

	if TranslationServer.get_locale() == "it":
		language_select.selected = 2



func _on_change_lang_button_pressed() -> void:
	if language_select.selected == 0:
		TranslationServer.set_locale("ar")
	if language_select.selected == 1:
		TranslationServer.set_locale("de")
	if language_select.selected == 2:
		TranslationServer.set_locale("it")
		
	SceneManager.load_main_menu()
