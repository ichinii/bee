extends Area2D
# comblicated
# comb post

export(Vector2) var comb_scale = Vector2(0.25, 0.25)
const comb_scene = preload("res://scenes/Comb.tscn")
const comb_script = preload("res://scripts/Comb.gd")
export(comb_script.CombType) var comb_type

var comb_size = Vector2(200, 350)
var combs: Dictionary


func _init() -> void:
	comb_size *= comb_scale

func _ready() -> void:
	combs = {}
	# create initial comb
	create_comb(Vector2(0,0))

""" use this function to create a new comb """
func place_new_comb() -> bool:
	var next_comb_pos = calc_next_comb_pos()
	if next_comb_pos == Vector2.INF:
		return false
	else:
		create_comb(next_comb_pos)
		return true

func create_comb(coord: Vector2) -> void:
	assert not combs.has(coord)
	
	var comb_pos = coord_to_pos(coord)
	var comb = comb_scene.instance()
	comb.scale = comb_scale
	comb.position = comb_pos
	comb.comb_type = comb_type
	
	combs[coord] = comb
	add_child(comb)

""" returns vector2.inf when no next coord available """
func calc_next_comb_pos() -> Vector2:
	var coords = combs.keys()
	coords.sort_custom(self, "compare_vector2")
	for coord in coords:
		var neighbors = get_neighbors(coord)
		neighbors.shuffle()
		var free_coord = get_free_comb_coord(neighbors)
		if free_coord != Vector2.INF:
			return free_coord
	
	return Vector2.INF

func get_free_comb_coord(coords: Array) -> Vector2:
	for coord in coords:
		if not combs.keys().has(coord) and is_comb_placeable(coord):
				return coord
	return Vector2.INF

func get_neighbors(coord: Vector2) -> Array:
	return [Vector2(coord.x - 0.5, coord.y - 0.5),
			Vector2(coord.x + 0.5, coord.y - 0.5), 
			Vector2(coord.x + 1.0, coord.y + 0.0), 
			Vector2(coord.x + 0.5, coord.y + 0.5), 
			Vector2(coord.x - 0.5, coord.y + 0.5), 
			Vector2(coord.x - 1.0, coord.y + 0.0)]

func is_comb_placeable(coord: Vector2) -> bool:
	var pos = coord_to_pos(coord)
	return IntersectionHelper.intersect_point(pos, name)

func coord_to_pos(coord: Vector2) -> Vector2:
	return coord * comb_size + $StartingPosition.position

func compare_vector2(v1: Vector2, v2: Vector2) -> bool:
	return v1.length_squared() < v2.length_squared()
	
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept"):
#		print(place_new_comb())