class_name ConditionBodyInteractedWithMapObject extends Condition

@export var body: PhysicsBody2D
@export var map_object: MapObjectInteractable

static func create(_body, _map_object):
	var instance = ConditionBodyInteractedWithMapObject.new()
	instance.body = _body
	instance.map_object = _map_object
	return instance


func _ready() -> void:
	if map_object and body:
		map_object.was_interacted_with.connect(_check_if_body_matches)
	else:
		push_warning("condition for body touching map_object missing map_object or body", name)
	
func _check_if_body_matches(body_that_interacted):
	if body_that_interacted == body:
		print(name, ": map_object condition fulfilled")
		fulfilled.emit()
