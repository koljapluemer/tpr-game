class_name AffordanceUnlocks extends Affordance

func _ready() -> void:
	super._ready()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	print("am I going to unlock?")
	
