extends Node2D

enum Option {
	NoneOption,
	SomeOption
}

var producer = null
var option = Option.NoneOption

func _ready():
	pass

func init(producer, pos, option):
	print("init RingMenuOption with option = ", option)
	self.producer = producer
	self.option = option
	self.position = pos
	_init_sprite()
	_init_area()

func _init_sprite():
	var sprite = Sprite.new()
	sprite.texture = preload("res://res/bee.png")
	sprite.position = self.position
	sprite.scale = Vector2(0.1, 0.1)
	add_child(sprite)

func _init_area():
	var area = Area2D.new()
	area.position = position
	area.scale = Vector2(1, 1)
	add_child(area)