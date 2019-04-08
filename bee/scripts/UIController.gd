extends CanvasLayer

# Enums
const CombType = preload("res://scripts/Comb.gd").CombType
const OptionType = preload("res://scripts/MenuOption.gd").OptionType

const _ring_menu_scene = preload("res://scenes/RingMenu.tscn")
onready var _camera2d: Camera2D = get_node("/root/Main/Camera2D")
onready var _bee_controller = get_node("/root/Main/BeeController")

var _activeMenu: Node = null
var _camera_moved: bool = false

func _ready() -> void:
	assert _camera2d != null
	_camera2d.connect("scrolled", self, "_on_Camera2D_scrolled")
	_camera2d.connect("zoomed", self, "_on_Camera2D_zoomed")
	
#and event.button_index == BUTTON_LEFT \
func _input(event: InputEvent) -> void:
	if event is DeviceHelper.get_touch_event_type() and !event.pressed:
			_close_active_menu()

func select_comb(event: InputEvent, producer: Object, comb_type: int) -> void:
	if !_camera_moved and !_close_active_menu():
		match comb_type:
			CombType.HONEY:
				_create_ring_menu(producer, event.position, [OptionType.COLLECT_NECTAR, OptionType.NEW_HONEY, OptionType.BUILD_COMB_HONEY])
			CombType.BEE:
				_create_ring_menu(producer, event.position, [OptionType.NEW_BEE, OptionType.BUILD_COMB_BEE])
	_camera_moved = false

func select_menu_option(event: InputEvent, producer: Object, option_type: int) -> void:
	if !_camera_moved and !_close_active_menu():
		match option_type:
			OptionType.COLLECT_NECTAR, OptionType.BUILD_COMB_HONEY, OptionType.BUILD_COMB_BEE, OptionType.NEW_HONEY, OptionType.NEW_BEE :
				_bee_controller.order_collect_nectar(1) # TODO @bruno the correct comb can be determined by the producer
				#print(producer.name) equals Comb
				print(option_type)
	_camera_moved = false
	
func select_bee(event: InputEvent) -> void:
	if !_camera_moved and !_close_active_menu():	
		print("bee selected") # can be implemented later
	_camera_moved = false

func _close_active_menu() -> bool:
	if _activeMenu:
		_activeMenu.queue_free()
		_activeMenu = null
		return true
	return false

func _create_ring_menu(producer: Object, pos: Vector2, options: Array) -> void:
	var ring_menu: Sprite = _ring_menu_scene.instance()
	_activeMenu = ring_menu
	ring_menu.position = pos
	add_child(ring_menu)
	ring_menu.setup(producer, options)
	
func _on_Camera2D_scrolled() -> void:
	if _close_active_menu():
		_camera_moved = true

func _on_Camera2D_zoomed() -> void:
	if _close_active_menu():
		_camera_moved = true