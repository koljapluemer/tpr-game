extends Control

@export var first_level: PackedScene

@onready var lang_select: OptionButton = %LangSelect
@onready var play_button: Button = %PlayButton


func _on_play_button_pressed() -> void:
	LevelManager.load_next_level()


func _on_lang_select_item_selected(index: int) -> void:
	Globals.set_locale(lang_from_index(index))
	play_button.disabled = false


func lang_from_index(index):	
	match index:
		0:
			return "arz"
		1:
			return "de"
		2:
			return "ar"
