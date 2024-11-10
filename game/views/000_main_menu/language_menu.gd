extends Control
@onready var language_select: OptionButton = %LanguageSelect

const CODES = {
	0: "ar",
	1: "de",
	2: "it"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var language_code = PlayerPreferencesManager.get_pref_language_code()
	for i in CODES:
		if CODES[i] == language_code:
			language_select.selected = i

func _on_change_lang_button_pressed() -> void:
	PlayerPreferencesManager.set_pref_language_code(CODES[language_select.selected])
	SceneManager.load_main_menu()
