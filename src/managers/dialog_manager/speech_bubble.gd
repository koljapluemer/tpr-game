extends MarginContainer
@onready var text_label: Label = %TextLabel


func set_text(text):
	text_label.text = text

func _ready():
	if Globals.language_code == "ar" or  Globals.language_code == "arz":
		position.x -= size.x - 10
