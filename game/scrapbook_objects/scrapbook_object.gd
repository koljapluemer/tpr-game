class_name ScrapbookObject extends Area2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## Must be an [Area2D] to fluently allow any kind of clicking, dragging and dropping, etc.


## [Word] array with words that this concrete [Node2D] may stand for.
## Likely nouns, such as CAR, TAXI, VEHICLE
@export var word_list: Array[String]
@export var color: String
@export var default_outline_thickness:= 8

## In true alchemy game fashion, this defines the actions possible
## by dropping another object onto this object
@export var scrapbook_interactions: Array[ScrapbookInteraction] = []
@export_category("Advanced Affordance Settings")
@export var is_movable:= true

## When taking the object (requires is_takeable)
## there is a little circular bar being filled ([member progress]).
## This determines how fast it will be filled
@export var taking_speed:= 3.0

@export var is_locked:= true
@export var lock_sound: AudioStream

@export var limit_movement_to_x := false


enum UI_STATE {PASSIVE, INTERACTABLE, HIGHLIGHTED, PRIMARY}
var current_ui_state:UI_STATE

var is_moving:= false
var mouse_offset_when_moved:Vector2

## the base words, like CAR and VEHICLE, but also CAR__LEFT and CAR__BLUE depending on what we can compare to
var sensible_identifiers: Array[String] = []
var grid_pos:Vector2i ## position on an imagined coordinate grid, passed down from parent spawnpoint


@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	if sprite_2d:
		#sprite_2d.material = sprite_2d.material.duplicate()
		set_interactable()
		pass

# TODO: this is a cursed non-state-machine
# stuff like things being highlighted (because they are a possible drop target)
# then become primary because they're hovered, then drop down 
# to highlighted again (not interactable!)
# are not reflected and almost impossible to reflect with this setup...		
func set_passive():
	current_ui_state = UI_STATE.PASSIVE
	#if sprite_2d:
		#sprite_2d.material.set_shader_parameter("line_thickness", 0)

func set_interactable():
	current_ui_state = UI_STATE.INTERACTABLE
	#if sprite_2d:
		#sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness)
		#sprite_2d.material.set_shader_parameter("line_color", Color.WHITE)

func set_highlighted():
	current_ui_state = UI_STATE.HIGHLIGHTED
	#if sprite_2d:
		#sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness * 1.5)
		#sprite_2d.material.set_shader_parameter("line_color", Color(0.45, 0.99, 0.75, 1))

func set_primary():
	current_ui_state = UI_STATE.PRIMARY
	#if sprite_2d:
		#sprite_2d.material = sprite_2d.material.duplicate()
		#sprite_2d.material.set_shader_parameter("line_thickness", default_outline_thickness * 2)
		#sprite_2d.material.set_shader_parameter("line_color", Color(0.87, 0.92, 0.45, 1))


## Currently handles two jobs: [br][br]
## 1) if the object [member is_takeable] and currently [member is_being_taken],
## we want to update the progress bar and possible [method enact_object_being_taken] in due time.  [br][br]
## 2) if the object [member is_moveable] and currently [member is_moving],
## we want it to follow the mouse.
## More importantly, we need to also listen for the end of "click" [Input] here,
## because the mouse may have left the [Area2D] of this object, so we cannot track the end of
## a drag and drop in [method _on_input_event] like the rest.
func _process(_delta: float) -> void:

			
	if is_moving:
		if limit_movement_to_x:
			global_position.x = get_global_mouse_position().x + mouse_offset_when_moved.x
		else:
			global_position = get_global_mouse_position() + mouse_offset_when_moved
			
		if Input.is_action_just_released("click"):
			is_moving = false
			MessageManager.object_drag_finished.emit(self)



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	
	if is_movable:
		if event.is_action_pressed("click"):
			is_moving = true
			mouse_offset_when_moved = global_position - get_global_mouse_position()
			MessageManager.object_drag_started.emit(self)
			# delayed signal for the interaction, so that MOVE quests
			# only succeed after the object was dragged around a bit
			get_tree().create_timer(0.4).connect(
				"timeout", func():MessageManager.object_was_moved.emit(self)
			)

func drop_other_obj_on_this_obj(obj:ScrapbookObject):
	print("drop on me registered;")
	print(word_list, ": i have the following nr of scrapbook interactions:", len(scrapbook_interactions))
	for scrapbook_interaction:ScrapbookInteraction in scrapbook_interactions:
		print("will check for keyword: ", scrapbook_interaction.key_word)
		print("obj word list: ", obj.word_list)
		if obj.word_list.has(scrapbook_interaction.key_word):
			print("keyword match")
			# at this point the combination is happening
			for instance in scrapbook_interaction.objects_to_spawn:
				# let parent spawnpoint handle itbird
				get_parent().change_scene(instance)
			MessageManager.objects_were_combined.emit(obj, self)
			if scrapbook_interaction.kill_sender:
				MessageManager.object_disappeared.emit(obj)
				obj.queue_free()
			if scrapbook_interaction.kill_receiver:
				MessageManager.object_disappeared.emit(self)
				queue_free()	
			break
	# check the same for the other object
	if is_instance_valid(self) and is_instance_valid(obj):	
		for scrapbook_interaction:ScrapbookInteraction in obj.scrapbook_interactions:
			if word_list.has(scrapbook_interaction.key_word):
				# at this point the combination is happening
				for instance in scrapbook_interaction.objects_to_spawn:
					# let parent spawnpoint handle itbird
					get_parent().change_scene(instance)
				MessageManager.objects_were_combined.emit(obj, self)
				if scrapbook_interaction.kill_receiver:
					MessageManager.object_disappeared.emit(obj)
					obj.queue_free()
				if scrapbook_interaction.kill_sender:
					MessageManager.object_disappeared.emit(self)
					queue_free()


func _on_mouse_entered() -> void:
	MessageManager.object_mouse_over_started.emit(self)

func _on_mouse_shape_exited() -> void:
	MessageManager.object_mouse_over_finished.emit(self)
