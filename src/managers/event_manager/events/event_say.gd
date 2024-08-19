class_name EventSay extends Event

@export var dialog: Dialog
@export var dialog_manager: DialogManager

func _ready() -> void:
	if end_condition:
		print("EventSay should not have an end_condition, it ends automatically after dialog finishes", name)
	super()

func _run():
	dialog_manager.say(dialog)
	dialog_manager.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished(finished_dialog):
	if finished_dialog == dialog:
		dialog_manager.dialog_finished.disconnect(_on_dialog_finished)
		finish()
