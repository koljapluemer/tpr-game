class_name Item extends Resource


@export var sprite: CompressedTexture2D
@export var resize_factor:float = 1
@export var offset = Vector2(0,0)
@export var collision_radius = 100
@export var interaction_radius = 300
@export_category("German")
@export var dative_form: String
@export var word: String
@export var interact_prompt: String
@export var interact_demo: String
