extends Node2D

enum BeeState { IDLE, COLLECT_NECTAR }

const NECTAR_POINT = Vector2(550, 480)
const COMB_POINT = Vector2(260, 1200)
const BEE_SPEED = 4

var current_task = null

class Task:
	func finished():
		assert false
	
	func tick_bee(bee):
		assert false

class CollectNectarTask extends Task:
	var has_nectar = false
	var nectar_point
	var comb_point
	
	func _init(n_point, c_point):
		self.nectar_point = n_point
		self.comb_point = c_point

	func finished():
		return false

	func tick_bee(bee):
		if has_nectar:
			var to_comb = self.comb_point - bee.position
			var diff = to_comb.length()
			to_comb = to_comb.clamped(BEE_SPEED)
			bee.position += to_comb
			if diff < 1:
				has_nectar = false
		else:
			var to_nectar = self.nectar_point - bee.position
			var diff = to_nectar.length()
			to_nectar = to_nectar.clamped(BEE_SPEED)
			bee.position += to_nectar
			if diff < 1:
				has_nectar = true

func _process(delta):
	# execute first task
	if current_task == null:
		_do_idle()
	else:
		current_task.tick_bee(self)

func idle():
	current_task = null

func is_idling():
	return current_task == null

func _do_idle():
	self.position.x += rand_range(-1, 1)
	self.position.y += rand_range(-1, 1)

func collect_nectar():
	current_task = CollectNectarTask.new(NECTAR_POINT, COMB_POINT)