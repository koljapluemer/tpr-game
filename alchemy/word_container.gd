extends PanelContainer

@onready var label: Label = %Label
@onready var texture_rect: TextureRect = %TextureRect

func set_data(word:Word):
	label.text = word.key
	texture_rect.texture = word.showcase_sprite
