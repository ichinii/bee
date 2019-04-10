extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 1.0

const MAX_X_SCROLL: int = 960
const MIN_X_SCROLL: int = 110
const MAX_Y_SCROLL: int = 1530
const MIN_Y_SCROLL: int = 710

const MID_X_SCROLL: int = (MAX_X_SCROLL + MIN_X_SCROLL) / 2
const MID_Y_SCROLL: int = (MAX_Y_SCROLL + MIN_Y_SCROLL) / 2

const SCROLL_SOFTNESS = 7

const SCROLL_UPDATE: float = 0.5
const MIN_SCROLL_THRESHOLD: int = 50

var mobile: bool = false
var zoom_value: float = 1.0
var scroll_position: Vector2 

signal scrolled()
signal zoomed()

func _ready() -> void:
	scroll_position = self.offset

func _camera2world(xy: Vector2):
	return xy - get_viewport_rect().size / 2 + scroll_position + (xy - get_viewport_rect().size / 2) * (zoom_value - 1)

class Contact:
	var index
	var position
	
	func _init(index, position):
		self.index = index
		self.position = position

	func as_text():
		return "Contact(index=" + str(index) + " position=" + str(position) + ")"

var contact_list = []

func _is_scrolling():
	return contact_list.size() == 1 || contact_list.size() == 2

func _is_zooming():
	return contact_list.size() == 2

func _scroll(event):
	var zfactor = 1.0
	if _is_zooming():
		zfactor = 0.5
	if mobile:
		if event is InputEventScreenDrag:
			self.scroll_position -= event.relative * self.zoom_value * zfactor
	else:
		if event is InputEventMouseMotion and event.button_mask != 0:
			self.scroll_position -= event.relative * self.zoom_value * zfactor

	var view_scroll = _scroll_smoother(self.scroll_position)
	var new_offset = _apply_scroll_threshold(view_scroll)
	if self.offset != new_offset:
		emit_signal("scrolled")

func _zoom(event):
	if event is InputEventScreenDrag:
		var updated_contact = null
		var unchanged_contact = null
		if contact_list[0].index == event.index:
			updated_contact = contact_list[1]
			unchanged_contact = contact_list[0]
		else:
			updated_contact = contact_list[0]
			unchanged_contact = contact_list[1]

		var old_diff = (updated_contact.position - event.relative) - unchanged_contact.position
		var new_diff = updated_contact.position - unchanged_contact.position
		
		var zoom_factor = new_diff.length() / old_diff.length()
		self.zoom_value *= zoom_factor

		var view_zoom = _zoom_smoother(self.zoom_value)
		self.zoom.x = view_zoom
		self.zoom.y = view_zoom
		emit_signal("zoomed")
	elif (not self.mobile) and (event is InputEventMouseButton):
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom_value -= 0.02
			emit_signal("zoomed")
		elif event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom_value += 0.02
			emit_signal("zoomed")

func _manage_contact_list(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if contact_list.size() < 2:
				var contact = Contact.new(event.index, event.position)
				contact_list.append(contact)
		else:
			for contact in contact_list:
				if contact.index == event.index:
					contact_list.erase(contact)
					break
	elif event is InputEventScreenDrag:
		for c in contact_list:
			if event.index == c.index:
				c.position = event.position

func _unhandled_input(event):
	if not mobile and (event is InputEventScreenTouch):
		mobile = true

	_manage_contact_list(event)

	if _is_scrolling() or not mobile:
		_scroll(event)
	if _is_zooming() or not mobile:
		_zoom(event)

func _zoom_back():
	if zoom_value < MIN_ZOOM:
		zoom_value += (MIN_ZOOM-zoom_value + 0.003)*0.2
		if zoom_value > MIN_ZOOM:
			zoom_value = MIN_ZOOM
	elif zoom_value > MAX_ZOOM:
		zoom_value -= (zoom_value-MAX_ZOOM + 0.003)*0.4
		if zoom_value < MAX_ZOOM:
			zoom_value = MAX_ZOOM

func _get_min_x_scroll():
	var capped_zoom_value = zoom_value
	if capped_zoom_value > MAX_ZOOM:
		capped_zoom_value = MAX_ZOOM
	return (capped_zoom_value * MID_X_SCROLL) + ((1-capped_zoom_value) * MIN_X_SCROLL)

func _get_max_x_scroll():
	var capped_zoom_value = zoom_value
	if capped_zoom_value > MAX_ZOOM:
		capped_zoom_value = MAX_ZOOM
	return (capped_zoom_value * MID_X_SCROLL) + ((1-capped_zoom_value) * MAX_X_SCROLL)

func _get_min_y_scroll():
	var capped_zoom_value = zoom_value
	if capped_zoom_value > MAX_ZOOM:
		capped_zoom_value = MAX_ZOOM
	return (capped_zoom_value * MID_Y_SCROLL) + ((1-capped_zoom_value) * MIN_Y_SCROLL)

func _get_max_y_scroll():
	var capped_zoom_value = zoom_value
	if capped_zoom_value > MAX_ZOOM:
		capped_zoom_value = MAX_ZOOM
	return (capped_zoom_value * MID_Y_SCROLL) + ((1-capped_zoom_value) * MAX_Y_SCROLL)
	
func _scroll_back():
	var min_x_scroll = _get_min_x_scroll()
	var max_x_scroll = _get_max_x_scroll()
	var min_y_scroll = _get_min_y_scroll()
	var max_y_scroll = _get_max_y_scroll()
	
	if scroll_position.x < min_x_scroll:
		scroll_position.x += (min_x_scroll-scroll_position.x + 0.3)*SCROLL_UPDATE
		if scroll_position.x > min_x_scroll:
			scroll_position.x = min_x_scroll
	elif scroll_position.x > max_x_scroll:
		scroll_position.x -= (scroll_position.x-max_x_scroll + 0.3)*SCROLL_UPDATE
		if scroll_position.x < max_x_scroll:
			scroll_position.x = max_x_scroll

	if scroll_position.y < min_y_scroll:
		scroll_position.y += (min_y_scroll-scroll_position.y + 0.3)*SCROLL_UPDATE
		if scroll_position.y > min_y_scroll:
			scroll_position.y = min_y_scroll
	elif scroll_position.y > max_y_scroll:
		scroll_position.y -= (scroll_position.y-max_y_scroll + 0.3)*SCROLL_UPDATE
		if scroll_position.y < max_y_scroll:
			scroll_position.y = max_y_scroll

func _process(_delta):
	if not _is_zooming():
		_zoom_back()

	if not _is_scrolling():
		_scroll_back()

	var view_zoom = _zoom_smoother(self.zoom_value)
	self.zoom.x = view_zoom
	self.zoom.y = view_zoom

	var view_scroll = _scroll_smoother(self.scroll_position)
	self.offset = _apply_scroll_threshold(view_scroll)

func _apply_scroll_threshold(scroll: Vector2):
	if self.offset.distance_squared_to(scroll) < MIN_SCROLL_THRESHOLD * self.zoom_value:
		return self.offset
	return scroll

func _scroll_smoother(s: Vector2):
	var max_x_scroll = _get_max_x_scroll()
	var min_x_scroll = _get_min_x_scroll()
	var max_y_scroll = _get_max_y_scroll()
	var min_y_scroll = _get_min_y_scroll()
	
	var r = s
	if s.x > max_x_scroll:
		r.x = max_x_scroll + _smooth_func(s.x-max_x_scroll, SCROLL_SOFTNESS*(zoom_value+0.5))
	elif s.x < min_x_scroll:
		r.x = min_x_scroll - _smooth_func(min_x_scroll-s.x, SCROLL_SOFTNESS*(zoom_value+0.5))

	if s.y > max_y_scroll:
		r.y = max_y_scroll + _smooth_func(s.y-max_y_scroll, SCROLL_SOFTNESS*(zoom_value+0.5))
	elif s.y < min_y_scroll:
		r.y = min_y_scroll - _smooth_func(min_y_scroll-s.y, SCROLL_SOFTNESS*(zoom_value+0.5))
	return r

func _zoom_smoother(z: float):
	var r = z
	if z > MAX_ZOOM:
		r = MAX_ZOOM + _smooth_func(z-MAX_ZOOM, 0.3)
	elif z < MIN_ZOOM:
		r = MIN_ZOOM - _smooth_func(MIN_ZOOM-z, 0.015)
	return r

func _smooth_func(x: float, h: float):
	return x*h/(x+h)