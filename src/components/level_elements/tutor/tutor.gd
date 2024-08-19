extends CharacterBody2D

signal target_reached

@export var speed : float = 100.0
@export var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
var target: Node2D
var current_state = State.Idle

enum State {
	Idle,
	IsDemonstrating
}

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	match current_state:
		State.IsDemonstrating:
			direction = target.global_position - global_position
			direction = direction.normalized()
			velocity.x = direction.x * speed
			velocity.y = direction.y * speed
			move_and_slide()
			update_animation()
			update_facing_direction()
			# if closer than 10 units, stop
			# set target to null, go idle
			if global_position.distance_to(target.global_position) < 10:
				target = null
				velocity = Vector2.ZERO
				animated_sprite.play("idle")
				target_reached.emit()
				current_state = State.Idle

func set_target(tar):
	target = tar
	current_state = State.IsDemonstrating
	
func update_animation():
	if direction.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false
		
# wrapper for show()
func show_object():
	if player:
		if global_position.x > player.global_position.x:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	show()
