extends Node2D

var modes:Dictionary

@onready var spawn_points: Node2D = %SpawnPoints
@onready var canvas_layer: CanvasLayer = %CanvasLayer


func _ready() -> void:
	if spawn_points:
		get_afforded_modes()
		canvas_layer.set_buttons(modes)
	else:
		push_warning(name, ": SpawnPoints holder missing")
	

func get_afforded_modes():
	for spawn_point:SpawnPoint in spawn_points.get_children():
		for mode in spawn_point.get_modes():
			# may want to disable buttons later, for now 
			# the boolean is meaningless but using a dict
			# assures unique keys
			modes[mode] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
