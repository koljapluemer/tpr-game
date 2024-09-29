extends Control

@onready var play_button: Button = %PlayButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneManager.reload_level()


func _on_language_option_button_item_selected(index: int) -> void:
	if index != -1:
		play_button.disabled = false
		match index:
			0:
				TranslationServer.set_locale("ar")
			1:
				TranslationServer.set_locale("de")
			2:
				TranslationServer.set_locale("it")
				
