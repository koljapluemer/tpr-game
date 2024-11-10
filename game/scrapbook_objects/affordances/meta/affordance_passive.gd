class_name AffordancePassive extends Affordance

func _ready() -> void:
	super()
	parent.object_dropped_on_me.connect(_on_object_dropped_on_parent)
	

# override if needed (likely needed :D)
func _on_object_dropped_on_parent(_obj:ScrapbookObject):
	pass
