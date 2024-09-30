extends Control

@onready var play_button: Button = %PlayButton
@onready var level_select: OptionButton = %LevelSelect
@onready var start_specific_level_button: Button = %StartSpecificLevelButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lvl_counter := 0
	for level in SceneManager.story:
		level_select.add_item("Level " + str(lvl_counter+1), lvl_counter)
		lvl_counter += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneManager.reload_level()


func _on_language_option_button_item_selected(index: int) -> void:
	if index != -1:
		play_button.disabled = false
		level_select.disabled = false
		match index:
			0:
				TranslationServer.set_locale("ar")
			1:
				TranslationServer.set_locale("de")
			2:
				TranslationServer.set_locale("it")
				


func _on_start_specific_level_button_pressed() -> void:
	if level_select.selected != -1:
		SceneManager.load_level_by_index(level_select.selected - 1)


func _on_level_select_item_selected(index: int) -> void:
	# enable level start button but only if we have 
	# both a language and a level selected
	if index != -1 and  not play_button.disabled:
		start_specific_level_button.disabled = false
