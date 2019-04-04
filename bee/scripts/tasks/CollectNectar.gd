extends Task

class_name CollectNectarTask

const BEE_SPEED = 200

enum BeeState { IN_HAS_NECTAR, IN_NO_NECTAR, OUT, FINISHED }

var nectar_point
var comb_point
var bee_state = BeeState.IN_NO_NECTAR
var out_counter
var out_counter_max
	
func _init(n_point, c_point, ocm):
	self.nectar_point = n_point
	self.comb_point = c_point
	self.out_counter_max = ocm

func finished():
	return bee_state == BeeState.FINISHED

func tick_bee(bee, delta):
	if bee_state == BeeState.IN_HAS_NECTAR:
		var to_comb = self.comb_point - bee.position
		var diff = to_comb.length()
		to_comb = to_comb.clamped(BEE_SPEED*delta)
		bee.position += to_comb
		if diff < 1:
			bee_state = BeeState.FINISHED
	elif bee_state == BeeState.IN_NO_NECTAR:
		var to_nectar = self.nectar_point - bee.position
		var diff = to_nectar.length()
		to_nectar = to_nectar.clamped(BEE_SPEED*delta)
		bee.position += to_nectar
		if diff < 1:
			bee_state = BeeState.OUT
			out_counter = out_counter_max + rand_range(-50, 50) / 50
			bee.fade_out()
	elif bee_state == BeeState.OUT:
		out_counter -= delta
		if out_counter < 0:
			bee_state = BeeState.IN_HAS_NECTAR
			bee.fade_in()