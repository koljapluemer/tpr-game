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

var affordances: Array[Affordance] = []


enum UI_STATE {PASSIVE, INTERACTABLE, HIGHLIGHTED, PRIMARY}
var current_ui_state:UI_STATE

var is_moving:= false
var mouse_offset_when_moved:Vector2

## the base words, like CAR and VEHICLE, but also CAR__LEFT and CAR__BLUE depending on what we can compare to
var sensible_identifiers: Array[String] = []
var grid_pos:Vector2i ## position on an imagined coordinate grid, passed down from parent spawnpoint
var parent_spawn_point: SpawnPoint

@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	MessageManager.object_appeared.emit(self)


## Currently handles two jobs: [br][br]
## 1) if the object [member is_takeable] and currently [member is_being_taken],
## we want to update the progress bar and possible [method enact_object_being_taken] in due time.  [br][br]
## 2) if the object [member is_moveable] and currently [member is_moving],
## we want it to follow the mouse.
## More importantly, we need to also listen for the end of "click" [Input] here,
## because the mouse may have left the [Area2D] of this object, so we cannot track the end of
## a drag and drop in [method _on_input_event] like the rest.

func get_possible_quest_keys() -> Array[String]:
	var keys: Array[String] = []
	for affordance in affordances:
		var res = affordance.get_key_for_quest()
		if res.is_valid_for_quest:
			keys.append(res.key)
	return keys
			

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
