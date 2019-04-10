extends Node2D

const NECTAR_POINT = Vector2(545, 716)
const COMB_POINT = Vector2(247, 1435)
const NECTAR_COLLECT_TIMER = 2

var current_task = null

func _ready() -> void:
	_update_bee_count()
	
func _update_bee_count() -> void:
	SingletonManager.player_stats.increase_bee_count()

func _process(delta):
	# execute first task
	if current_task == null:
		_do_idle()
	else:
		if current_task.finished():
			current_task = null
		else:
			current_task.tick_bee(self, delta)

func idle():
	current_task = null

func is_idling():
	return current_task == null

func _do_idle():
	self.position.x += rand_range(-1, 1)
	self.position.y += rand_range(-1, 1)

func collect_nectar():
	current_task = CollectNectarTask.new(NECTAR_POINT, COMB_POINT, NECTAR_COLLECT_TIMER)

func fade_out():
	$FadeTween.interpolate_property($Sprite,
									"modulate",
									Color(1, 1, 1, 1),
									Color(1, 1, 1, 0),
									1,
									Tween.TRANS_LINEAR,
									Tween.EASE_IN)
	$LightOccluder2D.light_mask = 0
	$FadeTween.interpolate_property(self,
									"position",
									self.position,
									self.position + Vector2(0, -20),
									1,
									Tween.TRANS_LINEAR,
									Tween.EASE_IN)
	$FadeTween.start()

func fade_in():
	$FadeTween.interpolate_property($Sprite,
									"modulate",
									Color(1, 1, 1, 0),
									Color(1, 1, 1, 1),
									1,
									Tween.TRANS_LINEAR,
									Tween.EASE_IN)
	$LightOccluder2D.light_mask = 1
	$FadeTween.interpolate_property(self,
									"position",
									self.position,
									self.position + Vector2(0, 20),
									1,
									Tween.TRANS_LINEAR,
									Tween.EASE_IN)
	$FadeTween.start()