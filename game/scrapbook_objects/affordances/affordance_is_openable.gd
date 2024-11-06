class_name AffordanceIsOpenable extends AffordanceActive

var click_in_action := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	parent.click_was_started.connect(_on_click)
	parent.click_was_released.connect(_on_click_released)


func _on_click() -> void:
	if not click_in_action:
		click_in_action = true
		get_tree().create_timer(0.2).connect(
			"timeout", _report_action
		)

# apparently can't use "just pressed" so here we go	
func _on_click_released() -> void:
	if click_in_action:
		click_in_action = false
	

func get_verb_key() -> String:
	return "OPEN"
