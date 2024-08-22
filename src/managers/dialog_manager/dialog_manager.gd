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
	var text = dialog.content
	kill_all_timer_children()
	dialog_box.get_node("%DialogContent").text = text
	dialog_box.visible = true
	# 0 kill_after means infinite
	if not kill_after == 0:
		create_kill_timer(kill_after)
	
	write_content_to_file(text)

func kill_all_timer_children():
	for child in get_children():
		if child is Timer:
			child.queue_free()

func finish():
	dialog_box.get_node("%DialogContent").text = ""
	dialog_box.visible = false
	dialog_finished.emit(current_dialog)
	current_dialog = null

func create_kill_timer(n):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", finish)
	timer.start()
	
	
func write_content_to_file(text):
	if not FileAccess.file_exists("user://dialogs.txt"):
		var	file = FileAccess.open("user://dialogs.txt", FileAccess.WRITE)
		file.close()
		
	var file = FileAccess.open("user://dialogs.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(text)
	file.close()
