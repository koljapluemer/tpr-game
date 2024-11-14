## allows fitting objects to disappear on drop on this object
class_name AffordanceCanHangThings extends AffordancePassive

@export var points: Array[Marker2D] = []


func _ready() -> void:
	super()


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceHangable:
			_report_action(obj, parent)
			obj.global_position = find_closest_point_to(obj).global_position
			obj.rotate(randi_range(-.1, .1))
			affordance.can_be_used_for_quests = false
			

func find_closest_point_to(to : Node2D) -> Node2D:
	var closest : Node2D = null
	var closest_distance : float = INF
	var to_position : Vector2 = to.global_position

	for node : Node2D in points:
		if node == to:
			continue
		var distance : float = to_position.distance_squared_to(node.global_position)
		if distance < closest_distance:
			closest = node
			closest_distance = distance

	return closest


func get_verb_key() -> String:
	return "HANG"
