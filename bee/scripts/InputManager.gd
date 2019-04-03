extends CanvasLayer
const TriggerType = Trigger.TriggerType

const ring_menu_scene = preload("res://scenes/RingMenu.tscn")
onready var camera2d: Camera2D = get_node("/root/Main/Camera2D")

var activeMenu: Node = null
var camera_moved: bool = false

func _ready() -> void:
	assert(camera2d != null)
	camera2d.connect("scrolled", self, "_on_Camera2D_scrolled")
	camera2d.connect("zoomed", self, "_on_Camera2D_zoomed")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and !event.pressed:
			closeActiveMenu()

func element_pressed(event: InputEvent, trigger_type) -> void:
	if !camera_moved:
		if !closeActiveMenu():
			match trigger_type:
				TriggerType.COMB:
					createRingMenu(self, event.position, [0, 0, 0, 0, 0, 0])
				TriggerType.OPTION:
					print("option") # TODO @bruno start here
	camera_moved = false

func closeActiveMenu() -> bool:
	if activeMenu:
		activeMenu.queue_free()
		activeMenu = null
		return true
	return false

func createRingMenu(producer: Object, pos: Vector2, options: Array) -> void:
	var ring_menu: Sprite = ring_menu_scene.instance()
	activeMenu = ring_menu
	ring_menu.position = pos
	add_child(ring_menu)
	ring_menu.setup(producer, options)

func _on_Camera2D_scrolled() -> void:
	closeActiveMenu()
	camera_moved = true

func _on_Camera2D_zoomed() -> void:
	closeActiveMenu()
	camera_moved = true