class_name EventShowUIElement extends Event

@export var ui_element:PackedScene

var ui:Node2D

func _run():
	ui = ui_element.instantiate()
	get_parent().add_child(ui)

func finish():
	ui.queue_free()
	super()
