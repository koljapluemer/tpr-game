class_name Event extends Node2D

signal finished

@export var start_condition: Condition
@export var end_condition: Condition
@export var delay_before_start = 0

func _ready() -> void:
	print("Event: event ready")
	if start_condition:
		start_condition.fulfilled.connect(request_run)
		print("connected to start condition")
	else:
		push_warning("warning: no start condition", name)

func request_run():
	print(name, ": Run requested")
	get_tree().create_timer(delay_before_start).connect("timeout", _run)

# run function, but allows delay after run call
func _run():
	if end_condition:
		end_condition.fulfilled.connect(finish)

func finish():
	finished.emit()
	#if start_condition:
		#if is_instance_valid(start_condition):
			#start_condition.queue_free()
	#if end_condition:
		#if is_instance_valid(end_condition):
			#end_condition.queue_free()
