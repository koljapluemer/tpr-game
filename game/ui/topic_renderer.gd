extends VBoxContainer

var topic: Topic

@onready var main_button: Button = %MainButton


func set_topic(_topic:Topic):
	topic = _topic
	main_button.icon = _topic.demo_image
