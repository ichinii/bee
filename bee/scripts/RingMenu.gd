extends Sprite

const menu_option_scene = preload("res://scenes/RingMenuOption.tscn")
const menu_option_script = preload("res://scenes/RingMenuOption.tscn")

func init(producer: Object, options: Array) -> void:
	for i in range(len(options)):
		var option_instance: Node = menu_option_scene.instance()
		option_instance.init(producer, position_of_option(i, len(options)), options[i])
		add_child(option_instance)

func position_of_option(index: float, size) -> Vector2:
	var r = 384
	var i = index / size * PI * 2 - PI / 2
	return r * Vector2(cos(i), sin(i))