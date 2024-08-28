extends Control

@export var first_level: PackedScene

@onready var lang_select: OptionButton = %LangSelect


func _on_play_button_pressed() -> void:
	LevelManager.load_next_level()


func _on_lang_select_item_selected(index: int) -> void:
	print(index)
	match index:
		0:
			Globals.set_locale("arz")
		1:
			Globals.set_locale("de")
		2:
			Globals.set_locale("ar")


func _ready() -> void:
	match lang_select.selected:
		0:
			Globals.set_locale("arz")
		1:
			Globals.set_locale("de")
		2:
			Globals.set_locale("ar")
