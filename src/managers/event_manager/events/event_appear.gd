class_name EventAppear extends Event

@export var appearing_node: Node

const FINGERPLOP = preload("res://src/managers/event_manager/fingerplop.mp3")

@onready var audio_player = get_tree().get_first_node_in_group("audio_player")

func _ready() -> void:
	if end_condition:
		push_warning("appear event is over instantly and should not have an end condition", name)
	super()
	
func _run():
	if appearing_node.visible == false:
		audio_player.stream = FINGERPLOP
		audio_player.play()
		if appearing_node.has_method("show_object"):
			appearing_node.show_object()
		else:
			appearing_node.visible = true
			push_warning("warning: object sheduled to appear, but missing method")

	finish()

static func create_from_map_object(map_object:MapObject):
	var instance = EventAppear.new()
	instance.appearing_node = map_object
	return instance 
