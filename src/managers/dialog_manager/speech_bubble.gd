extends MarginContainer
@onready var text_label: Label = %TextLabel


func set_text(text):
	text_label.text = text
