class_name EventSay extends Event

@export var dialog: Dialog

@onready var dialog_manager: DialogManager = get_tree().get_first_node_in_group("dialog_manager")

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
	print(name, ": dialog event finished")
	finish()
	
	
static func create_from_map_object(instruction, map_object: MapObject):
	var instance = EventSay.new()
	var dialog = Dialog.create_from_map_object(instruction, map_object)
	instance.dialog = dialog
	return instance

static func create(say_what: String):
	var instance = EventSay.new()
	var dialog = Dialog.create(say_what)
	instance.dialog = dialog
	return instance
