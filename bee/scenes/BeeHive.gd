extends Node2D

func _ready() -> void:
	$InitialComb/AnimatedSprite.animation = "comb_cell"
	$TransitionTween.interpolate_property($HiveSprite, "modulate", Color(1,1,1,1), 
	Color(1,1,1,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$TransitionTween.start()

func _on_TransitionTween_tween_completed(object: Object, key: NodePath) -> void:
	$InitialComb.visible = true
	$HiveSprite.queue_free()
