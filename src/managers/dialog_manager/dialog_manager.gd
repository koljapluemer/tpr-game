class_name DialogManager extends Node

signal dialog_finished


const DIALOG_BOX = preload("res://src/managers/dialog_manager/dialog_box.tscn")
var  dialog_box: CanvasLayer 

var current_dialog: Dialog

func _ready():
	dialog_box = DIALOG_BOX.instantiate()
	add_child(dialog_box)
	dialog_box.visible = false

func say(dialog, kill_after=5):
	# TODO: instead of kill_after, at least have
	# the option to see how long the audio is and do that times something or so
	# maybe even a user test how fast u can read
	var text = dialog.content
	dialog_box.get_node("%DialogContent").text = text
	dialog_box.visible = true
	write_content_to_file(text)
	
	get_tree().create_timer(kill_after).connect("timeout", finish)



func finish():
	dialog_box.get_node("%DialogContent").text = ""
	dialog_box.visible = false
	dialog_finished.emit(current_dialog)
	current_dialog = null
	

	
	
func write_content_to_file(text):
	if not FileAccess.file_exists("user://dialogs.txt"):
		var	file = FileAccess.open("user://dialogs.txt", FileAccess.WRITE)
		file.close()
		
	var file = FileAccess.open("user://dialogs.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(text)
	file.close()
