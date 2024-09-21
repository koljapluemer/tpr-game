extends GridContainer

@onready var button_mode_move: Button = %ButtonModeMove
@onready var button_mode_take: Button = %ButtonModeTake

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_mode_move.pressed.connect(_set_mode_move)
	button_mode_take.pressed.connect(_set_mode_take)

func _set_mode_move():
	Globals.current_mode = InteractionMode.MOVE
	
func _set_mode_take():
	Globals.current_mode = InteractionMode.TAKE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
