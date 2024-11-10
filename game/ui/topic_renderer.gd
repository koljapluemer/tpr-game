class_name TopicRenderer extends VBoxContainer

const ICON_LOCK = preload("res://game/shared_assets/icon-lock.svg")
var topic: Topic

@onready var main_button: Button = %MainButton
@onready var star_label: Label = %StarLabel

var is_locked := false


func set_topic(_topic:Topic):
	topic = _topic
	if topic.stars_to_unlock <= LanguageLearningDataManager.get_earned_stars():
		main_button.icon = _topic.demo_image
		is_locked = false
	else:
		main_button.icon = ICON_LOCK
		main_button.disabled = true
		is_locked = true


func _on_main_button_pressed() -> void:
	SceneManager.change_topic_to(topic)

func set_stars(nr_of_stars:int):
	var stars_string = ""
	for i in range(nr_of_stars):
		stars_string += "*"
	star_label.text = stars_string
