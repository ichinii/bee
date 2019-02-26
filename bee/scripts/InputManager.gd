extends Control

var activeMenu = null

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton \
			and event.button_index == BUTTON_LEFT \
			and event.is_pressed():
		#closeActiveMenu()
		createRingMenu(self, event.position / 2, [])

func closeActiveMenu():
	if activeMenu:
		print("close active menu")
		activeMenu.free()
		activeMenu = null
		return true
	return false

func createRingMenu(producer, pos, options):
	if !closeActiveMenu():
		print("create RingMenu with options = ", options)
		var ring_menu_scene = preload("res://scenes/RingMenu.tscn")
		var ring_menu = ring_menu_scene.instance()
		ring_menu.init(producer, pos, options)
		activeMenu = ring_menu
		add_child(ring_menu)