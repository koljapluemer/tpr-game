class_name ScrapbookObject extends Area2D

## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## Must be an [Area2D] to fluently allow any kind of clicking, dragging and dropping, etc.

## sent if the object (which is_movable) has just stopped moving
## ...and may now want to engange in a [ScrapbookInteraction] if it has been
## dropped on another [ScrapbookObject]
signal movement_stopped 

## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var word_list: WordList
@export var color:ObjectColor ## A special type of [Word] that allows alternative descriptions to be used in quests

@export_category("Affordances")
@export var is_touchable := true
@export var is_movable := true
@export var is_takeable := false
@export var is_lockable := false
## In true alchemy game fashion, this defines the actions possible
## by dropping another object onto this object
@export var scrapbook_interactions: Array[ScrapbookInteraction] = []
@export_category("Advanced Affordance Settings")

## When taking the object (requires is_takeable)
## there is a little circular bar being filled ([member progress]).
## This determines how fast it will be filled
@export var taking_speed:= 3.0

@export var is_locked:= true
@export var lock_sound: AudioStream
const LOCK_UNLOCK = preload("res://game/interactions/interactions/lock_unlock.tres")
const MOVE = preload("res://game/interactions/interactions/move.tres")
const TAKE = preload("res://game/interactions/interactions/take.tres")
const TOUCH = preload("res://game/interactions/interactions/touch.tres")

var is_moving:= false
var is_being_taken := false

@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D

func _ready() -> void:
	pass

## Currently handles two jobs: [br][br]
## 1) if the object [member is_takeable] and currently [member is_being_taken],
## we want to update the progress bar and possible [method enact_object_being_taken] in due time.  [br][br]
## 2) if the object [member is_moveable] and currently [member is_moving],
## we want it to follow the mouse.
## More importantly, we need to also listen for the end of "click" [Input] here,
## because the mouse may have left the [Area2D] of this object, so we cannot track the end of
## a drag and drop in [method _on_input_event] like the rest.
func _process(delta: float) -> void:
	if is_being_taken:
		progress.value += taking_speed
		if progress.value >= 100:
			enact_object_being_taken()
			is_being_taken = false
			progress.value = 0
			
	if is_moving:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			is_moving = false
		movement_stopped.emit(self)

	
func enact_object_being_taken():
	MessageManager.object_was_interacted_with.emit(self, TAKE)
	MessageManager.object_disappeared.emit(self)
	queue_free()	
	
func get_affordances() -> Array[Interaction]:
	var affordances: Array[Interaction] = []
	if is_movable:
		affordances.append(MOVE)
	if is_takeable:
		affordances.append(TAKE)
	if is_lockable:
		affordances.append(LOCK_UNLOCK)
	if is_touchable:
		affordances.append(TOUCH)
		
		
	return affordances


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if is_movable and GameState.current_interaction_mode == MOVE:
		if event.is_action_pressed("click"):
			is_moving = true
			get_tree().create_timer(0.25).connect(
				"timeout", func():MessageManager.object_was_interacted_with.emit(self, MOVE)
			)

	if is_takeable and GameState.current_interaction_mode == TAKE:
		if event.is_action_pressed("click") and not is_being_taken:
			viewport.set_input_as_handled()
			is_being_taken = true
			progress.show()
		if event.is_action_released("click"):
			is_being_taken = false
			progress.value = 0
			progress.hide()
			
	if is_touchable and GameState.current_interaction_mode == TOUCH:
		if event.is_action_pressed("click"):
			print(name, ": was touched")
			viewport.set_input_as_handled()
			MessageManager.object_was_interacted_with.emit(self, TOUCH)
			
	if is_lockable and GameState.current_interaction_mode == LOCK_UNLOCK:
		if event.is_action_pressed("click"):
			if audio_player and lock_sound:
				audio_player.stream = lock_sound
				audio_player.play()
			is_locked = !is_locked
			MessageManager.object_was_interacted_with.emit(self, LOCK_UNLOCK)
			


func _on_area_entered(area: Area2D) -> void:
	if area is ScrapbookObject:
		area.movement_stopped.connect(_on_other_object_dropped_on_to_me)


func _on_area_exited(area: Area2D) -> void:
	if area is ScrapbookObject:
		area.movement_stopped.disconnect(_on_other_object_dropped_on_to_me)

func _on_other_object_dropped_on_to_me(obj:ScrapbookObject):
	for scrapbook_interaction in scrapbook_interactions:
		if obj.word_list.words.has(scrapbook_interaction.key_word):
			# at this point the combination is happening
			MessageManager.objects_were_combined.emit(obj, self)
			for instance in scrapbook_interaction.objects_to_spawn:
				# let parent spawnpoint handle itbird
				get_parent().change_scene(instance)
			if scrapbook_interaction.kill_receiver:
				MessageManager.object_disappeared.emit(self)
				queue_free()
			if scrapbook_interaction.kill_sender:
				obj.queue_free()

		
		
		
		
