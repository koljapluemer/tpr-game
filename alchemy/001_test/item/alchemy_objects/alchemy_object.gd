class_name AlchemyObject extends Node2D

signal alchemy_object_taken

@export var words: Array[Word] = []
@export var color:ObjectColor

@onready var components: Node2D = %Components

func _ready() -> void:
	if not components:
		push_warning(name, ": is missing Components holder.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_modes():
	var modes: Array[String] = []
	for component in components.get_children():
		modes.append(component.get_mode_name())
	return modes
		
