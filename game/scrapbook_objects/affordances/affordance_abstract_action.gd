class_name AffordanceAbstractAction extends Affordance

@export_category("uh?")
@export var allow_unspecific := true

@export var abstract_action:AbstractAction

func _ready() -> void:
	super._ready()
	if not abstract_action:
		push_warning(name, ": has no abstract action defined")


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	print("am I going to act?")
	
