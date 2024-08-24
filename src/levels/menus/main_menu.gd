extends Control

@export var first_level: PackedScene

@onready var lang_select: OptionButton = %LangSelect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(first_level)


func _on_lang_select_item_selected(index: int) -> void:
	print(index)
	match index:
		0:
			Globals.set_locale("de")
		1:
			Globals.set_locale("ar")
