extends CharacterBody2D

signal interacting_with

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var object_currently_interacting_with: MapObjectInteractable

enum State {
	Idle,
	IsWalking,
	Interacting
}

var current_state: State = State.Idle

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite


func _physics_process(delta: float) -> void:
	# Add the gravity (just needed for spawn fall down, actually kind of silly
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction != 0:
		current_state = State.IsWalking
		update_facing_direction(direction)
	else:
		# interacting cannot be interrupted by doing nothing
		if current_state != State.Interacting:
			set_idle()
			
	update_animation()

func set_idle():
	current_state = State.Idle

	
func update_animation():
	match current_state:
		State.IsWalking:
			player_sprite.play("walk")
		State.Interacting:
			player_sprite.play("interact")
		State.Idle:
			player_sprite.play("idle")
			
func update_facing_direction(direction):
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true

func interact_with_object(object):
	# TODO: what happens if interacting w/ objects rapidly?
	print("player interacting")
	if object.global_position > global_position:
		player_sprite.flip_h = false
	else:
		player_sprite.flip_h = true
		
	current_state = State.Interacting
	update_animation()
	object_currently_interacting_with = object
	player_sprite.animation_finished.connect(finish_interacting)
	interacting_with.emit(object_currently_interacting_with)


func finish_interacting():
	current_state = State.Idle
