class_name ConditionBodyTouchedArea extends Condition

@export var body: PhysicsBody2D
@export var area: Area2D

func _ready() -> void:
	if area and body:
		area.body_entered.connect(_check_if_entered_body_matches)
	else:
		push_warning("condition for body touching area missing area or body", name)
	
func _check_if_entered_body_matches(body_that_entered):
	print("body ", body_that_entered.name,  " entered area ", area.name, "; checking against: ", body.name)
	if body_that_entered == body:
		print(name, ": area condition fulfilled")
		fulfilled.emit()
