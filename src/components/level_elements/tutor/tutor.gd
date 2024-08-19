extends CharacterBody2D

signal has_reached_target

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

func _ready() -> void:
	if not player:
		print("Player Object not set, tutor cannot turn to player.")


func _physics_process(delta):
	if visible:
		match current_state:
			State.IsDemonstrating:
				direction = target.global_position - global_position
				direction = direction.normalized()
				velocity.x = direction.x * speed
				velocity.y = direction.y * speed
				move_and_slide()
				update_animation()
				update_facing_direction()
			State.Idle:
				# turn to player
				if player:
					if global_position.x > player.global_position.x:
						animated_sprite.flip_h = true
					else:
						animated_sprite.flip_h = false

func walk_to_node(tar):
	target = tar
	current_state = State.IsDemonstrating
	
func _on_body_entered_target_are(body):
	if body == self:
		has_reached_target.emit()
		target = null
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		current_state = State.Idle
		
func update_animation():
	if direction.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func update_facing_direction():
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false
		
# wrapper for show()
func show_object():
	show()
	
