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
@export var word_list: Array[String]
@export var color: String
@export var default_outline_thickness:= 8

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

enum UI_STATE {PASSIVE, INTERACTABLE, HIGHLIGHTED, PRIMARY}
var current_ui_state:UI_STATE

var is_moving:= false
var is_being_taken := false
## the base words, like CAR and VEHICLE, but also CAR__LEFT and CAR__BLUE depending on what we can compare to
var sensible_identifiers: Array[String] = []
var grid_pos:Vector2 ## position on an imagined coordinate grid, passed down from parent spawnpoint


@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	if sprite_2d:
		#sprite_2d.material = sprite_2d.material.duplicate()
		set_interactable()
		pass
		
func set_passive():
	current_ui_state = UI_STATE.PASSIVE
	if sprite_2d:
		sprite_2d.material.set_shader_parameter("line_thickness", 0)

func set_interactable():
	current_ui_state = UI_STATE.INTERACTABLE
	if sprite_2d:
		sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness)
		sprite_2d.material.set_shader_parameter("line_color", Color.WHITE)

func set_highlighted():
	print("setting highlight")
	current_ui_state = UI_STATE.HIGHLIGHTED
	if sprite_2d:
		sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness * 1.5)
		sprite_2d.material.set_shader_parameter("line_color", Color(0.45, 0.99, 0.75, 1))

func set_primary():
	print("setting primary")
	current_ui_state = UI_STATE.PRIMARY
	if sprite_2d:
		sprite_2d.material = sprite_2d.material.duplicate()
		sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness * 2)
		sprite_2d.material.set_shader_parameter("line_color", Color(0.87, 0.92, 0.45, 1))
		print('should be reflected..?')
	else:
		print('no sprite?!')


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
			MessageManager.object_drag_finished.emit(self)


	
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
			MessageManager.object_drag_started.emit(self)
			# delayed signal for the interaction, so that MOVE quests
			# only succeed after the object was dragged around a bit
			get_tree().create_timer(0.25).connect(
				"timeout", func():MessageManager.object_was_interacted_with.emit(self, MOVE)
			)

	if is_takeable and GameState.current_interaction_mode == TAKE:
		if event.is_action_pressed("click") and not is_being_taken:
			is_being_taken = true
			progress.show()
		if event.is_action_released("click"):
			is_being_taken = false
			progress.value = 0
			progress.hide()
			
	if is_touchable and GameState.current_interaction_mode == TOUCH:
		if event.is_action_pressed("click"):
			print(name, ": was touched")
			MessageManager.object_was_interacted_with.emit(self, TOUCH)
			
	if is_lockable and GameState.current_interaction_mode == LOCK_UNLOCK:
		if event.is_action_pressed("click"):
			if audio_player and lock_sound:
				audio_player.stream = lock_sound
				audio_player.play()
			is_locked = !is_locked
			MessageManager.object_was_interacted_with.emit(self, LOCK_UNLOCK)
			


func _on_area_entered(area: Area2D) -> void:
	pass


func drop_other_obj_on_this_obj(obj:ScrapbookObject):
	# TODO: should be obsolete and now handled by level_manager
	# likely needs to be rewritten a bit only
	print("object dropped on me")
	for scrapbook_interaction in scrapbook_interactions:
		if obj.word_list.has(scrapbook_interaction.key_word):
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


func _on_mouse_entered() -> void:
	MessageManager.object_mouse_over_started.emit(self)


func react_to_being_hovered() -> void:
	if current_ui_state == UI_STATE.PASSIVE:
		return
	match GameState.current_interaction_mode:
		TAKE:
			if is_takeable:
				set_primary()
		MOVE:
			print("is move")
			if is_movable:
				print("is movable")
				set_primary()
		TOUCH:
			if is_touchable:
				set_primary()
		LOCK_UNLOCK:
			if is_lockable:
				set_primary()

func _on_mouse_shape_exited() -> void:
	MessageManager.object_mouse_over_finished.emit(self)
