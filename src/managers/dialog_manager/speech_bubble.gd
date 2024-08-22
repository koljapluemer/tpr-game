extends Node2D

signal finished_displaying

@export var letter_time = 0.03
@export var space_time = 0.06
@export var punctuation_time = 0.2

const MAX_WIDTH = 512
var text = ""
var letter_index = 0

@onready var label: Label = %TextLabel
@onready var letter_timer: Timer = %LetterTimer

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y / 2
	
	
