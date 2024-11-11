## Holds several level, but works as a kind of level
## on the UI level: the user selects a topic to play and 
## from it levels are randomly selected
class_name Topic extends Resource


@export var internal_name:String
@export var demo_image:CompressedTexture2D
@export var points_to_unlock:= 0
@export var tutorial_levels: Array[PackedScene] = []
@export var level_rotation:Array[PackedScene] = []
