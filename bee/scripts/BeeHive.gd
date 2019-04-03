extends Node2D

func _ready() -> void:
	$TransitionTween.interpolate_property($HiveSprite, "modulate", Color(1,1,1,1), 
	Color(1,1,1,0), 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$TransitionTween.interpolate_property($Light2D, "energy", 0.0, 0.6, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	$TransitionTween.start()

func _on_TransitionTween_tween_completed(object: Object, key: NodePath) -> void:
	$HiveSprite.queue_free()
