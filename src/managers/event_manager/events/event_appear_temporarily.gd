class_name EventAppearTemporarily extends Event

@export var appearing_node: Node
@export var auto_hide_at_start = true

const FINGERPLOP = preload("res://src/managers/event_manager/fingerplop.mp3")

@onready var audio_player = get_tree().get_first_node_in_group("audio_player")


func _ready():
	if not end_condition:
		push_warning("warning: no end condition", name)
	if auto_hide_at_start:
		appearing_node.hide()
	super()

func _run():
	print("running event show thingie temporarily")
	# show object is an optional wrapper around show
	if appearing_node.has_method("show_object"):
		appearing_node.show_object()
	else:
		appearing_node.show()
	audio_player.stream = FINGERPLOP
	audio_player.play()
	super()

func finish():
	appearing_node.hide()
	super()
