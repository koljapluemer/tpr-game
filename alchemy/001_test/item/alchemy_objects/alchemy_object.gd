class_name AlchemyObject extends Node2D

signal alchemy_object_taken

@export var words: Array[Word] = []
@export var color:ObjectColor
@export_category("Components")
@export var takeable_component: TakeableComponent
@export var lockable_component: LockableComponent

var affords: Array[InteractionMode] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if takeable_component:
		takeable_component.object_taken.connect(_on_taken)

func _on_taken():
	alchemy_object_taken.emit(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
