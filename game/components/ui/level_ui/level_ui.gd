## The user interface visible while playing a level
extends CanvasLayer
@onready var hot_bar: HBoxContainer = %HotBar

func set_buttons(modes:Dictionary):
	hot_bar.set_buttons(modes)
	
