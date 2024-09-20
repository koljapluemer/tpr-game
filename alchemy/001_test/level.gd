extends Node2D

var currentMode: InteractionMode

@onready var hot_bar: GridContainer = %HotBar
@onready var mode_debug: Label = %ModeDebug


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in hot_bar.get_children():
		button.mode_button_pressed.connect(_on_mode_button_pressed)

func _on_mode_button_pressed(mode):
	currentMode = mode
	mode_debug.text = currentMode.mode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
