extends Node2D

enum Option {
	NoneOption,
	SomeOption
}

const bee_texture = preload("res://res/bee.png")

var producer: Object = null
var option = Option.NoneOption

func init(producer: Object, pos: Vector2, option):
	self.producer = producer
	self.position = pos
	self.option = option
	_init_sprite()
	_init_area()

func _init_sprite():
	var sprite = Sprite.new()
	sprite.texture = bee_texture
	sprite.position = self.position
	sprite.scale = Vector2(1, 1)
	add_child(sprite)

func _init_area():
	var area = Area2D.new()
	area.position = position
	area.scale = Vector2(1, 1)
	add_child(area)

