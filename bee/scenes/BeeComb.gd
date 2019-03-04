extends Node2D

var placeholder_scene = preload("res://scenes/PlaceholderComb.tscn")

func _init() -> void:
	#for x in range(-1, 1):
	#	for y in range(-1, 1):
	var placeholder = placeholder_scene.instance()
	$".".add_child(placeholder)
	placeholder.position = position + Vector2(-100,-175)
	print(position)
