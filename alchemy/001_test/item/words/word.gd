## Abstract representation of a word.
## Raison d'etre is tracking progress of individual words,
## and prioritizing which objects to load.
class_name Word extends Resource

@export var key:String
@export var showcase_sprite:Texture2D

@export_category("---")
@export var word_group: Array[String] = ["WORD"]
