class_name Quest extends Node2D

@export_group("Quest Settings")
@export var quest_description: String
@export var start_dialog: Dialog
@export var end_dialog: Dialog
@export var is_available = false

@onready var state_chart: StateChart = %StateChart

func _ready():
	state_chart.set_expression_property("is_available", is_available)
