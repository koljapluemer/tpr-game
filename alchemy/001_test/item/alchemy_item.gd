class_name AlchemyObject extends Node2D

signal alchemy_object_taken

@export var key:String
@export_category("Components")
@export var takeable_component: TakeableComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if takeable_component:
		print("connected component")
		takeable_component.object_taken.connect(_on_taken)

func _on_taken():
	print("obj taken")
	alchemy_object_taken.emit(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
