class_name AffordancePassive extends Affordance

@export var allow_quest_where_i_am_acted_upon_by_an_unspecified_obj := true

func _ready() -> void:
	super()
	parent.object_dropped_on_me.connect(_on_object_dropped_on_parent)
	

# override if needed
func _on_object_dropped_on_parent(obj:ScrapbookObject):
	pass
