class_name EventSay extends Event

@export var dialog: Dialog
@export var dialog_manager: DialogManager

func _ready() -> void:
	if end_condition:
		push_warning("EventSay should not have an end_condition, it ends automatically after dialog finishes", name)
	super()

func _run():
	dialog_manager.say(dialog)
	dialog_manager.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished(finished_dialog):
	# TODO: will this be trouble if dialog manager gets multiple dialogs?
	dialog_manager.dialog_finished.disconnect(_on_dialog_finished)
	finish()
