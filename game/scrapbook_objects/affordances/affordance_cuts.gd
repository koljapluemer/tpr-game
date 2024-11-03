class_name AffordanceCuts extends Affordance

func _ready() -> void:
	super._ready()
	Logger.log(0, "Cuts Registered ", ["CUT-KIWI"])


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	print("am I going to cut?")
	
