class_name ScrapbookObject extends Node2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## usually is made out of a sprite and at least one [Area2D], which
## is needed to make the [AlchemyObject] ineractable via components

## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var words: Array[Word] = []
@export var color:ObjectColor ## A special type of [Word] that allows alternative descriptions to be used in quests

@onready var components: Node2D = %Components

func _ready() -> void:
	if not components:
		push_warning(name, ": is missing Components holder.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_modes() -> Array[Interaction]:
	var modes: Array[Interaction] = []
	for component:InteractionComponent in components.get_children():
		modes.append(component.interaction)
	return modes
