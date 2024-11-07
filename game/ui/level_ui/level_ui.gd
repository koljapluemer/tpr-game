## The manager for the user interface visible while playing a level
extends CanvasLayer

@onready var popup: Popup = %Popup
@onready var quest_label = %QuestLabel

func _ready() -> void:
	# TODO: decide and document whether
	# message_manager or quest_manager sends this...
	MessageManager.quest_started.connect(add_active_quest)
	MessageManager.quest_ended.connect(remove_quest)

func add_active_quest(quest:Quest):
	quest_label.show()
	quest_label.text = str(quest)

func remove_quest(_quest:Quest):
	quest_label.hide()
	quest_label.text = ""

func _on_restart_button_pressed() -> void:
	SceneManager.reload_level()

func _on_end_button_pressed() -> void:
	SceneManager.load_end_level_screen()

func _on_main_menu_button_pressed() -> void:
	SceneManager.load_main_menu()
	


func _on_menu_button_pressed() -> void:
	popup.visible = true
