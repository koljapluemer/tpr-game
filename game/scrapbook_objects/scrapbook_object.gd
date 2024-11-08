class_name ScrapbookObject extends Area2D
## Holds a concrete [Node2D] representing an object which can be interacted with in the game.
## E.g. may be a car, a cat, or an apple.
## Must be an [Area2D] to fluently allow any kind of clicking, dragging and dropping, etc.

signal click_was_started
signal click_was_released
signal object_dropped_on_me(obj:ScrapbookObject)
signal hover_hint_state_changed_to(active_obj:ScrapbookObject, receiving_obj:ScrapbookObject)

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

var is_moving := false
var mouse_offset_when_moved: Vector2
var currently_overlapped_areas: Array[ScrapbookObject] = []
var mainly_hovered_object: ScrapbookObject

@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D




func _ready() -> void:
	MessageManager.object_appeared.emit(self)

func _process(delta: float) -> void:
	if is_moving:
		global_position = get_global_mouse_position() + mouse_offset_when_moved

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		Logger.log(0, "Click on " + name)
		click_was_started.emit()


func _input(event):
	if event.is_action_released("click"):
		_stop_moving()


func register_affordance(affordance:Affordance):
	affordances.append(affordance)
	Logger.log(0, "Affordance registered + " + affordance.name)
	

func get_identifiers() -> Array[String]:
	var ids: Array[String] = []
	for id in sensible_identifiers:
		var key := id
		if parent_spawn_point.relative_position:
			key += "__" + parent_spawn_point.relative_position
			if parent_spawn_point.relative_position_relates_to_spawn_point:
				if parent_spawn_point.relative_position_relates_to_spawn_point.init_scene:
					for related_id in parent_spawn_point.relative_position_relates_to_spawn_point.init_scene.get_identifiers():
						ids.append(key + "__" + related_id)
			else:
				ids.append(key)
		else:
			ids.append(key)
	return ids

func _start_moving():
	if not is_moving:
		is_moving = true
		MessageManager.object_started_moving.emit(self)
		mouse_offset_when_moved = global_position - get_global_mouse_position()
		hover_hint_state_changed_to.emit(self, null)

func _stop_moving():
	if is_moving:
		is_moving = false
		hover_hint_state_changed_to.emit(null, null)
		MessageManager.object_stopped_moving.emit(self)
		var areas: Array[Area2D]= get_overlapping_areas()
		for area in areas:
			if area is ScrapbookObject:
				area.object_dropped_on_me.emit(self)

func _on_area_entered(area: Area2D) -> void:
	if is_moving and area is ScrapbookObject:
		currently_overlapped_areas.append(area)
		hover_hint_state_changed_to.emit(self, area)


func _on_area_exited(area: Area2D) -> void:
	currently_overlapped_areas.erase(area)
	if area == mainly_hovered_object:
		hover_hint_state_changed_to.emit(self, null)
