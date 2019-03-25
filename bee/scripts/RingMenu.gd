extends Node2D

enum Option {
	SomeOption,
	AnotherOption
}

func _ready():
	pass

func init(producer, pos, options):
	print("init RingMenu with options = ", options)
	var ring_menu_option_scene = preload("res://scenes/RingMenuOption.tscn")
	var ring_menu_option = ring_menu_option_scene.instance()
	var option = Option.AnotherOption
	if options.size() > 0:
		option = Option.SomeOption
	ring_menu_option.init(producer, pos, option)
	add_child(ring_menu_option)