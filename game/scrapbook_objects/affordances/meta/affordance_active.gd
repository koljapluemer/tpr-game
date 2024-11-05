class_name AffordanceActive extends Affordance

@export var is_independent := true

var passive_objects_that_can_be_interacted_with : Array[ScrapbookObject] = []


func _ready() -> void:
	super()
	MessageManager.object_list_changed.connect(_on_object_list_changed)


func _do_interactions_with_objects_I_was_dropped_on(areas:Array[Area2D]):
	for area in areas:
			if area is ScrapbookObject:
				area.object_dropped_on_me.emit(parent)


func get_possible_passive_objects_that_affordance_can_interact_with() -> Array[ScrapbookObject]:
	var objects: Array[ScrapbookObject] = []
	if get_is_independent():
		print("appending null")
		objects.append(null)
	for obj in passive_objects_that_can_be_interacted_with:
		objects.append(obj)
	
	return objects


# override (if partners are of interest)
func _on_object_list_changed(objects:Array[ScrapbookObject]):
	pass
	
# override for stuff that need no partner, like mOVE or OPEN
func get_is_independent() -> bool:
	return false
