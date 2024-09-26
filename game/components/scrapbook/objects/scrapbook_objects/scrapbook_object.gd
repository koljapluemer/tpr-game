class_name ScrapbookObject extends Area2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## usually is made out of a sprite and at least one [Area2D], which
## is needed to make the [AlchemyObject] ineractable via components


#signal movement_stopped(obj:ScrapbookObject)
signal movement_stopped

## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var word_list: WordList
@export var color:ObjectColor ## A special type of [Word] that allows alternative descriptions to be used in quests

@export_category("Affordances")
@export var is_movable := true
@export var is_takeable := false
@export var is_lockable := false
@export var scrapbook_interactions: Array[ScrapbookInteraction] = []

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
				movement_stopped.emit(self)


func _on_area_entered(area: Area2D) -> void:
	if area is ScrapbookObject:
		area.movement_stopped.connect(_on_other_object_dropped_on_to_me)


func _on_area_exited(area: Area2D) -> void:
	if area is ScrapbookObject:
		area.movement_stopped.disconnect(_on_other_object_dropped_on_to_me)

func _on_other_object_dropped_on_to_me(obj:ScrapbookObject):
	for scrapbook_interaction in scrapbook_interactions:
		if obj.word_list.words.has(scrapbook_interaction.key_word):
			for instance in scrapbook_interaction.objects_to_spawn:
				# let parent spawnpoint handle it
				get_parent().change_scene(instance)
			if scrapbook_interaction.kill_receiver:
				queue_free()
			if scrapbook_interaction.kill_sender:
				obj.queue_free()

		
		
		
		
