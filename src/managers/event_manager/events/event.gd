class_name Event extends Node2D

signal finished


@export var start_condition: Condition
@export var end_condition: Condition
@export var delay_before_start = 0


enum EventStatus {
	blocked,
	ready,
	started, 
	done
}

# TODO: is this still relevant? maybe for debugging
var current_status = EventStatus.blocked

func _ready() -> void:
	if start_condition:
		start_condition.fulfilled.connect(request_run)
	else:
		print("warning: no start condition", name)
	if end_condition:
		end_condition.fulfilled.connect(finish)
	else:
		print("warning: no end condition", name)

func request_run():
	get_tree().create_timer(delay_before_start).connect("timeout", _run)

# run function, but allows delay after run call
func _run():
	current_status = Event.EventStatus.started

func finish():
	finished.emit()
	if start_condition:
		start_condition.queue_free()
	if end_condition:
		end_condition.queue_free()
