class_name ConditionBodyTouchedMapObject extends Condition

@export var body: PhysicsBody2D
@export var map_object: MapObject

static func create(body, map_object):
	var instance = ConditionBodyTouchedMapObject.new()
	instance.body = body
	instance.map_object = map_object
	return instance


func _ready() -> void:
	if map_object and body:
		map_object.body_entered.connect(_check_if_entered_body_matches)
	else:
		push_warning("condition for body touching map_object missing map_object or body", name)
	
func _check_if_entered_body_matches(body_that_entered):
	print("body ", body_that_entered.name,  " entered map_object ", map_object.name, "; checking against: ", body.name)
	if body_that_entered == body:
		print(name, ": map_object condition fulfilled")
		fulfilled.emit()
