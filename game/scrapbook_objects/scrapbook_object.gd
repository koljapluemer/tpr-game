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
@export var secondary_color: String

const y_coord_upper_screen_edge = 0
const y_coord_lower_screen_edge = 300 
const scale_lower_bound = 0.5
const scale_upper_bound = 2

var original_position: Vector2

# filled by affordances in tree registering themselves
var affordances: Array[Affordance] = []

## the base words, like CAR and VEHICLE, but also CAR__LEFT and CAR__BLUE depending on what we can compare to
var sensible_identifiers: Array[String] = []
var parent_spawn_point: SpawnPoint

var is_moving := false
var mouse_offset_when_moved: Vector2
var currently_overlapped_areas: Array[ScrapbookObject] = []
var mainly_hovered_object: ScrapbookObject


@onready var progress: TextureProgressBar = %Progress
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D


func _ready() -> void:
	MessageManager.object_appeared.emit(self)
	original_position = global_position
	#adapt_scale()

func _process(_delta: float) -> void:
	if is_moving:
		global_position = get_global_mouse_position() + mouse_offset_when_moved
		#adapt_scale()
		
#func adapt_scale():
	#var current_y := global_position.y
	#if current_y < original_position.y:
		#var t = (current_y - y_coord_upper_screen_edge) / (original_position.y - y_coord_upper_screen_edge)
		#scale.x = lerp(1, scale_lower_bound, t) * parent_spawn_point.scale_factor
		#scale.y = lerp(1, scale_lower_bound, t) * parent_spawn_point.scale_factor
	#else:
		#var t = (current_y - original_position.y) / (y_coord_lower_screen_edge - original_position.y)
		#scale.x = lerp(1, scale_upper_bound, t) * parent_spawn_point.scale_factor
		#scale.y = lerp(1, scale_upper_bound, t) * parent_spawn_point.scale_factor

			
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		click_was_started.emit()


func _input(event):
	if event.is_action_released("click"):
		_stop_moving()
		click_was_released.emit()


func register_affordance(affordance:Affordance):
	affordances.append(affordance)
	Logger.log(0, "Affordance registered + " + affordance.name)
	

func get_identifiers() -> Array[String]:
	return sensible_identifiers

func _start_moving():
	if not is_moving:
		is_moving = true
		MessageManager.object_started_moving.emit(self)
		mouse_offset_when_moved = global_position - get_global_mouse_position()
		# bit of a cheap hack but catches the "hey I'm already in the area" problem
		for area in get_overlapping_areas():
			if area is ScrapbookObject:
				mainly_hovered_object = area
		hover_hint_state_changed_to.emit(self, mainly_hovered_object)

func _stop_moving():
	if is_moving:
		is_moving = false
		hover_hint_state_changed_to.emit(null, null)
		MessageManager.object_stopped_moving.emit(self)
		if mainly_hovered_object:
			mainly_hovered_object.object_dropped_on_me.emit(self)


func _on_area_entered(area: Area2D) -> void:
	if is_moving and area is ScrapbookObject:
		currently_overlapped_areas.append(area)
		mainly_hovered_object = area
		hover_hint_state_changed_to.emit(self, mainly_hovered_object)


func _on_area_exited(area: Area2D) -> void:
	var overlapping_areas:= get_overlapping_areas()
	var overlapping_objects: Array[ScrapbookObject] = []
	for _area in overlapping_areas:
		if _area is ScrapbookObject:
			overlapping_objects.append(_area)
	currently_overlapped_areas = overlapping_objects
	
	if area == mainly_hovered_object:
		mainly_hovered_object = null
		hover_hint_state_changed_to.emit(self, mainly_hovered_object)
