class_name AffordanceAbstractProperty extends Affordance

@export var allow_unspecific := true
@export var abstract_property:AbstractProperty

func _ready() -> void:
	super._ready()
	if not abstract_property:
		push_warning(name, ": has no abstract property defined")



func _on_object_dropped_on_parent(obj:ScrapbookObject):
	print("am I going to be acted upon?")
	
