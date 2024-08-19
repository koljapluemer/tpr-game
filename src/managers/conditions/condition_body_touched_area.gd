class_name ConditionBodyTouchedArea extends Condition

@export var body: PhysicsBody2D
@export var area: Area2D

func _ready() -> void:
	if area and body:
		area.body_entered.connect(_check_if_entered_body_matches)
	else:
		print("condition for body touching area missing area or body", name)
	
func _check_if_entered_body_matches(body_that_entered):
	print("body entered area", body_that_entered)
	print("checking against: ", body )
	if body_that_entered == body:
		fulfilled.emit()
