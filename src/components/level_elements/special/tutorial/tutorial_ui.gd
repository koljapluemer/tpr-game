extends CanvasLayer

@export var tutorial_text: String = ""

@onready var label: Label = %Label

func _ready() -> void:
	label.text = tutorial_text
