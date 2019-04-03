extends Node2D

""" properties for intersect_point """
const max_results: int = 4
const exclude: Array = []
const layer_mask: int = 0x7FFFFFFF
const collide_with_bodies: bool = true
const collide_with_areas: bool = true

func intersect_point(point: Vector2, collider_name: String):
	var arr = get_world_2d().get_direct_space_state().intersect_point(point, max_results, exclude, layer_mask, collide_with_bodies, collide_with_areas)
	for a in arr:
		if a.collider.name == collider_name:
			return true
	return false
