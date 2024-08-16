class_name Sequence extends Node2D

@export var events:Array[Event] = []
@export var activates_quests: Array[Quest] = []
@export var activates_sequence: Sequence

var current_event: Event 

func start():
	run_random_ready_event()
	
func run_random_ready_event():
	var ready_events = []
	for event in events:
		print('Event', event)
		if event.current_status == Event.EventStatus.ready:
			ready_events.append(event)
	current_event = ready_events.pick_random()
	current_event.run()
	current_event.finished.connect(run_random_ready_event)
	
			
