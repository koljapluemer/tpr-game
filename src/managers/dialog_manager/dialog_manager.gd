class_name DialogManager extends Node

signal dialog_finished

var current_dialog: String

@onready var speech_bubble: MarginContainer = %SpeechBubble

func _ready():
	speech_bubble.visible = false

func say(dialog, kill_after=5):
	# TODO: instead of kill_after, at least have
	# the option to see how long the audio is and do that times something or so
	# maybe even a user test how fast u can read
	speech_bubble.set_text(dialog)
	speech_bubble.visible = true
	write_content_to_file(dialog)
	get_tree().create_timer(kill_after).connect("timeout", finish)



func finish():
	speech_bubble.visible = false
	dialog_finished.emit(current_dialog)
	current_dialog = ""
	

# this is just for now to have an overview what sound/dialog i need	
func write_content_to_file(text):
	var	file
	if not FileAccess.file_exists("dialogs.txt"):
		file = FileAccess.open("dialogs.txt", FileAccess.WRITE)
		file.close()
		
	file = FileAccess.open("dialogs.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(text)
	file.close()
