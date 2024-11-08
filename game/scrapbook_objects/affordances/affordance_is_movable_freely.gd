class_name AffordanceIsMovableFreely extends AffordanceActive

func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click_started)


func _on_click_started() -> void:
	parent._start_moving()
	# delayed signal for the interaction, so that MOVE quests
	# only succeed after the object was dragged around a bit
	print("click started")
	get_tree().create_timer(0.4).connect(
		"timeout", _report_action.bind(parent, null)
	)

			 
func get_verb_key() -> String:
	return "MOVE"
	
func get_is_independent() -> bool:
	return true
