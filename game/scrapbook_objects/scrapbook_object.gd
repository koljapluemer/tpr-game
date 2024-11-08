class_name ScrapbookObject extends Area2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## Must be an [Area2D] to fluently allow any kind of clicking, dragging and dropping, etc.

signal click_was_started
signal click_was_released
signal object_dropped_on_me(obj:ScrapbookObject)

## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var word_list: Array[String]
@export var color: String
@export var default_outline_thickness:= 8

# filled by affordances in tree registering themselves
var affordances: Array[Affordance] = []

## the base words, like CAR and VEHICLE, but also CAR__LEFT and CAR__BLUE depending on what we can compare to
var sensible_identifiers: Array[String] = []
var grid_pos:Vector2i ## position on an imagined coordinate grid, passed down from parent spawnpoint
var parent_spawn_point: SpawnPoint

@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D


func _ready() -> void:
	MessageManager.object_appeared.emit(self)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		Logger.log(0, "Click on " + name)
		click_was_started.emit()


func _input(event):
	if event.is_action_released("click"):
		Logger.log(0, "Input Event Click Ended on " + name)
		click_was_released.emit()


func register_affordance(affordance:Affordance):
	affordances.append(affordance)
	Logger.log(0, "Affordance registered + " + affordance.name)
