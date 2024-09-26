class_name ScrapbookObject extends Area2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## usually is made out of a sprite and at least one [Area2D], which
## is needed to make the [AlchemyObject] ineractable via components

## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var word_list: WordList
@export var color:ObjectColor ## A special type of [Word] that allows alternative descriptions to be used in quests

@export_category("Affordances")
@export var is_movable := true
@export var is_takeable := false
@export var is_lockable := false


const LOCK_UNLOCK = preload("res://game/components/interactions/interactions/lock_unlock.tres")
const MOVE = preload("res://game/components/interactions/interactions/move.tres")
const TAKE = preload("res://game/components/interactions/interactions/take.tres")

var is_moving:= false

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		global_position = get_global_mouse_position()

	
func get_affordances() -> Array[Interaction]:
	var affordances: Array[Interaction] = []
	if is_movable:
		affordances.append(MOVE)
	if is_takeable:
		affordances.append(TAKE)
	if is_lockable:
		affordances.append(LOCK_UNLOCK)
		
	return affordances
		


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_movable and GameState.current_interaction_mode == MOVE:
		if event.is_action_pressed("click"):
				is_moving = true
		if event.is_action_released("click"):
				is_moving = false
