extends Node

signal dialog_finished

@onready var dialog_box: CanvasLayer = %Dialogdialog_box
@onready var dialog_icon: TextureRect = %DialogIcon
@onready var dialog_content: Label = %DialogContent


func _ready():
	dialog_box.visible = false

func say(dialog, kill_after=5):
	var text = dialog.content
	kill_all_timer_children()
	dialog_content.text = text
	dialog_box.visible = true
	# 0 kill_after means infinite
	if not kill_after == 0:
		create_kill_timer(kill_after)

func kill_all_timer_children():
	for child in get_children():
		if child is Timer:
			child.queue_free()

func finish():
	dialog_content.text = ""
	dialog_box.visible = false
	emit_signal("dialog_finished")

func create_kill_timer(n):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", finish)
	timer.start()
