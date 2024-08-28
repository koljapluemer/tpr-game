extends MarginContainer
@onready var text_label: Label = %TextLabel


func _ready() -> void:
	Globals.language_changed.connect(adapt_to_locale)

func set_text(text):
	text_label.text = text

func adapt_to_locale(locale):
	if locale == "ar" or locale == "arz":
		print("adapting to LTR")
		position.x -= size.x - 10
