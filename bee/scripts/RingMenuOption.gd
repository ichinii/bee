extends Sprite

enum Option {
	NoneOption,
	SomeOption
}

const bee_texture = preload("res://res/bee.png")

var producer: Object = null
var option = Option.NoneOption

func setup(producer: Object, pos: Vector2, option) -> void:
	self.producer = producer
	self.position = pos
	self.option = option
	texture = bee_texture

