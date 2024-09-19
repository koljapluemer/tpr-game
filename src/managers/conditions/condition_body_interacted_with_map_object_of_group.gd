class_name ConditionBodyInteractedWithMapObjectWithGroup extends Condition

@export var body: PhysicsBody2D
@export var group_string: String = ""

static func create(_body, _group):
	var instance = ConditionBodyInteractedWithMapObject.new()
	instance.body = _body
	instance.group_string = _group
	return instance


func _ready() -> void:
	if group_string != "" and body:
		for node in get_tree().get_nodes_in_group(group_string):
			node.was_interacted_with.connect(_check_if_body_matches)
	else:
		push_warning("condition for body touching map_object missing map_object or body", name)
	
func _check_if_body_matches(body_that_interacted):
	if body_that_interacted == body:
		print(name, ": body interactiond condition fulfilled")
		fulfilled.emit()
