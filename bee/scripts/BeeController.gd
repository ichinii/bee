extends Node2D

const bee_scene = preload("res://scenes/Bee.tscn")
const NUM_START_BEES = 3
const BEE_DEFAULT_START_POSITION = Vector2(530, 600)

var bees = []

func _generate_bee_start_position():
	return Vector2(BEE_DEFAULT_START_POSITION.x + rand_range(-100, 100),
				   BEE_DEFAULT_START_POSITION.y + rand_range(-100, 100))

func _ready():
	randomize()
	for i in range(NUM_START_BEES):
		var bee = bee_scene.instance()
		bee.position = _generate_bee_start_position()
		bees.append(bee)
		self.add_child(bee)

func _get_idle_bees():
	var idle_bees = []
	for bee in bees:
		if bee.is_idling():
			idle_bees.append(bee)
	return idle_bees

func order_collect_nectar(num_bees):
	var idle_bees = _get_idle_bees()
	idle_bees.shuffle()
	num_bees = min(num_bees, idle_bees.size())
	for i in range(num_bees):
		idle_bees[i].collect_nectar()