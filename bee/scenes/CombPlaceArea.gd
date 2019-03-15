extends Area2D
# comblicat
# comb post

var comb_size = Vector2(200, 350)
var combs = {}
var comb_scene = preload("res://scenes/Comb.tscn")

func _ready() -> void:
	create_comb(Vector2(0,0))

func create_comb(coord: Vector2) -> void:
	assert not combs.has(coord)
	
	var comb_pos = coord_to_pos(coord)
	var comb = comb_scene.instance()
	comb.position = comb_pos
	combs[coord] = comb
	add_child(comb)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var next_comb_pos = calc_next_comb_pos()
		assert next_comb_pos != null
		create_comb(next_comb_pos)
		
func calc_next_comb_pos():
	var coords = combs.keys()
	coords.sort_custom(self, "compare_vector2")
	for coord in coords:
		var neighbors = get_neighbors(coord)
		neighbors.shuffle()
		var new_comb_coord = get_free_comb_coord(neighbors)
		if new_comb_coord:
			return new_comb_coord
	
	return null
			

func get_free_comb_coord(coords):
	for coord in coords:
		if not combs.has(coord) and is_comb_placeable(coord):
			return coord
	
	return null

func get_neighbors(coord: Vector2):
	return [Vector2(coord.x - 0.5, coord.y - 0.5),
			Vector2(coord.x + 0.5, coord.y - 0.5), 
			Vector2(coord.x + 1.0, coord.y + 0.0), 
			Vector2(coord.x + 0.5, coord.y + 0.5), 
			Vector2(coord.x - 0.5, coord.y + 0.5), 
			Vector2(coord.x - 1.0, coord.y + 0.0)]
			
func is_comb_placeable(coord: Vector2) -> bool:
	var pos = coord_to_pos(coord)
	
	var arr = get_world_2d().direct_space_state.intersect_point(position)
	#print(arr)
	return arr.has(self)

func coord_to_pos(coord: Vector2) -> Vector2:
	return coord * comb_size + $StartPosition.position

func compare_vector2(v1: Vector2, v2: Vector2) -> bool:
	return v1.length_squared() < v2.length_squared()