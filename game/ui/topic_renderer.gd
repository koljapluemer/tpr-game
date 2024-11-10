class_name TopicRenderer extends VBoxContainer

const ICON_LOCK = preload("res://game/shared_assets/icon-lock.svg")
var topic: Topic

@onready var main_button: Button = %MainButton
@onready var star_label: Label = %StarLabel

var is_locked := false


func set_topic(_topic:Topic):
	topic = _topic
	if topic.points_to_unlock <= LanguageLearningDataManager.get_earned_points():
		main_button.icon = _topic.demo_image
		is_locked = false
	else:
		main_button.icon = ICON_LOCK
		main_button.disabled = true
		is_locked = true


func _on_main_button_pressed() -> void:
	SceneManager.change_topic_to(topic)

func set_points(nr_of_points:int):
	star_label.text = str(nr_of_points) + ' Points'
