extends Node2D

enum Option {
	NoneOption,
	SomeOption
}

func _ready():
	pass

func init(producer, pos, options):
	print("init RingMenu with options = ", options)
	var ring_menu_option_scene = preload("res://scenes/RingMenuOption.tscn")
	for i in range(len(options)):
		var option_instance = ring_menu_option_scene.instance()
		option_instance.init(producer, pos + position_of_option(i, len(options)), options[i])
		add_child(option_instance)

func position_of_option(index: float, size):
	var r = 32
	var i = index / size * PI * 2 - PI / 2
	return r * Vector2(cos(i), sin(i))