class_name Event extends Node2D

@export var duration = 0
@export var delay_before_start = 0
@export var is_initially_blocked = true

@export var readies_events:Array[Event]


signal finished

enum EventStatus {
	blocked,
	ready,
	started, 
	done
}

var current_status: EventStatus

func _ready() -> void:
	if is_initially_blocked:
		current_status = EventStatus.blocked
	else:
		current_status = EventStatus.ready

func request_run():
	get_tree().create_timer(duration).connect("timeout", _run)
	if duration != 0:
		get_tree().create_timer(duration).connect("timeout", finish)
	pass

# run function, but allows delay after run call
func _run():
	current_status = Event.EventStatus.started
	

func finish():
	for event in readies_events:
		event.current_status = Event.EventStatus.ready
	finished.emit()
