## defines actions like TAKE or WALK_TO that are generally possible in the game.
## relevant both for hot_bar [InteractionButton] as well as [InteractionComponent]
class_name Interaction extends Resource

@export var key:String
@export var icon:Texture2D
@export var cursor:Texture2D

@export var create_button = true
