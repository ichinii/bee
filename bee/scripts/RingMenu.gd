extends Sprite

const menu_option_scene = preload("res://scenes/RingMenuOption.tscn")
const menu_option_script = preload("res://scenes/RingMenuOption.tscn")

func _ready() -> void:
	$TransitionTween.interpolate_property(self, "scale", Vector2(0,0),
			self.scale, 0.75, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$TransitionTween.interpolate_property(self, "rotation_degrees", 90,
			self.rotation_degrees, 0.75, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$TransitionTween.start()
	
func setup(producer: Object, options: Array) -> void:
	
	for i in range(len(options)):
		var option_instance: Node = menu_option_scene.instance()
		option_instance.setup(producer, position_of_option(i, len(options)), options[i])
		add_child(option_instance)

func position_of_option(index: float, size) -> Vector2:
	var r = 768
	var i = index / size * PI * 2 - PI / 2
	return r * Vector2(cos(i), sin(i))