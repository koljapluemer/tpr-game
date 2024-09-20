class_name TakeableObject extends Node2D

signal object_destroyed

const ANCHOR_CROP = preload("res://alchemy/001_test/sprites/anchor_crop.png")
const APPLE_CROP = preload("res://alchemy/001_test/sprites/apple_crop.png")
const BACKPACK_BLUE_CROP = preload("res://alchemy/001_test/sprites/backpack_blue_crop.png")
const BACKPACK_RED_CROP = preload("res://alchemy/001_test/sprites/backpack_red_crop.png")
const BALL_CROP = preload("res://alchemy/001_test/sprites/ball_crop.png")
const BANANA_CROP = preload("res://alchemy/001_test/sprites/banana_crop.png")
const BOOKS_CROP = preload("res://alchemy/001_test/sprites/books_crop.png")
const BOTTLE_1_CROP = preload("res://alchemy/001_test/sprites/bottle_1_crop.png")
const BOTTLE_2_CROP = preload("res://alchemy/001_test/sprites/bottle_2_crop.png")
const BREAD_CROP = preload("res://alchemy/001_test/sprites/bread_crop.png")
const BURSH_CROP = preload("res://alchemy/001_test/sprites/bursh_crop.png")
const CAMERA_CROP = preload("res://alchemy/001_test/sprites/camera_crop.png")

const sprites = [ANCHOR_CROP, APPLE_CROP, BACKPACK_BLUE_CROP, BACKPACK_RED_CROP,
BALL_CROP, BANANA_CROP, BOOKS_CROP, BOTTLE_1_CROP, BOTTLE_2_CROP, BREAD_CROP, BURSH_CROP, CAMERA_CROP]


@onready var sprite_2d: Sprite2D = %Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = sprites.pick_random()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		object_destroyed.emit(self)
		queue_free()
