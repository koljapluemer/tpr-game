class_name Event extends Node2D

@export var delay_before_start = 0
@export var readies_events:Array[Event]


signal finished

enum EventStatus {
	blocked,
	ready,
	started, 
	done
}

@export var current_status: EventStatus

func run():
	# implement this!
	pass

func finish():
	for event in readies_events:
		event.current_status = Event.EventStatus.ready
	finished.emit()
