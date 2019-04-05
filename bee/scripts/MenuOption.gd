extends Sprite

enum OptionType { 
	COLLECT_NECTAR, 
	BUILD_COMB_HONEY, 
	BUILD_COMB_BEE, 
	NEW_HONEY, 
	NEW_BEE 
}

var option_type: int
var producer: Object

const _collect_nectar_texture = preload("res://res/collect_nectar.png")
const _build_comb_texture = preload("res://res/build_comb.png")
const _new_honey_texture = preload("res://res/new_honey.png")
const _new_bee_texture = preload("res://res/new_bee.png")

func setup(producer: Object, pos: Vector2, option_type: int) -> void:
	self.option_type = option_type
	self.producer = producer
	position = pos
	match self.option_type:
		OptionType.COLLECT_NECTAR:
			texture = _collect_nectar_texture 
		OptionType.BUILD_COMB_HONEY, OptionType.BUILD_COMB_BEE: 
			texture = _build_comb_texture
		OptionType.NEW_HONEY:
			texture = _new_honey_texture
		OptionType.NEW_BEE: 
			texture = _new_bee_texture 
