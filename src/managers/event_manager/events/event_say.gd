class_name EventSay extends Event

@export var dialog: Dialog
@export var dialog_manager: DialogManager

func _run():
	dialog_manager.say(dialog)
