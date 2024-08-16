class_name EventWalk extends Event

@export var dialog: Dialog
@export var dialog_manager: Node2D

func run():
	dialog_manager.say(dialog)
