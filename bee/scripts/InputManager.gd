extends Control

var activeMenu = null

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton \
			and event.button_index == BUTTON_LEFT \
			and event.is_pressed():
		if !closeActiveMenu():
			var position = $"/root/Main/Camera2D"._camera2world(event.position) / 2 #TODO: why '/2' ?
			createRingMenu(self, position, [0, 0, 0, 0, 0, 0])

func closeActiveMenu():
	if activeMenu:
		print("close active menu")
		activeMenu.free()
		activeMenu = null
		return true
	return false

func createRingMenu(producer, pos, options):
	print("create RingMenu with options = ", options)
	var ring_menu_scene = preload("res://scenes/RingMenu.tscn")
	var ring_menu = ring_menu_scene.instance()
	ring_menu.init(producer, pos, options)
	activeMenu = ring_menu
	add_child(ring_menu)

func _on_Camera2D_scrolled():
	print("scrolled")
	closeActiveMenu()

func _on_Camera2D_zoomed():
	print("zoomed")
	closeActiveMenu()