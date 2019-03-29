extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 2.0

const MAX_X_SCROLL: int = 900
const MIN_X_SCROLL: int = 170
const MAX_Y_SCROLL: int = 1270
const MIN_Y_SCROLL: int = 500

const SCROLL_UPDATE: float = 0.5

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
	if self.offset != view_scroll:
		self.offset = view_scroll
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

func _scroll_back():
	if scroll_position.x < MIN_X_SCROLL:
		scroll_position.x += (MIN_X_SCROLL-scroll_position.x + 0.3)*SCROLL_UPDATE
		if scroll_position.x > MIN_X_SCROLL:
			scroll_position.x = MIN_X_SCROLL
	elif scroll_position.x > MAX_X_SCROLL:
		scroll_position.x -= (scroll_position.x-MAX_X_SCROLL + 0.3)*SCROLL_UPDATE
		if scroll_position.x < MAX_X_SCROLL:
			scroll_position.x = MAX_X_SCROLL

	if scroll_position.y < MIN_Y_SCROLL:
		scroll_position.y += (MIN_Y_SCROLL-scroll_position.y + 0.3)*SCROLL_UPDATE
		if scroll_position.y > MIN_Y_SCROLL:
			scroll_position.y = MIN_Y_SCROLL
	elif scroll_position.y > MAX_Y_SCROLL:
		scroll_position.y -= (scroll_position.y-MAX_Y_SCROLL + 0.3)*SCROLL_UPDATE
		if scroll_position.y < MAX_Y_SCROLL:
			scroll_position.y = MAX_Y_SCROLL

func _process(delta):
	if not _is_zooming():
		_zoom_back()

	if not _is_scrolling():
		_scroll_back()
		
	var view_zoom = _zoom_smoother(self.zoom_value)
	self.zoom.x = view_zoom
	self.zoom.y = view_zoom

	var view_scroll = _scroll_smoother(self.scroll_position)
	self.offset = view_scroll

func _scroll_smoother(s):
	var r = s
	if s.x > MAX_X_SCROLL:
		r.x = MAX_X_SCROLL + _smooth_func(s.x-MAX_X_SCROLL, 5*(zoom_value+0.5))
	elif s.x < MIN_X_SCROLL:
		r.x = MIN_X_SCROLL - _smooth_func(MIN_X_SCROLL-s.x, 5*(zoom_value+0.5))

	if s.y > MAX_Y_SCROLL:
		r.y = MAX_Y_SCROLL + _smooth_func(s.y-MAX_Y_SCROLL, 5*(zoom_value+0.5))
	elif s.y < MIN_Y_SCROLL:
		r.y = MIN_Y_SCROLL - _smooth_func(MIN_Y_SCROLL-s.y, 5*(zoom_value+0.5))

	return r

func _zoom_smoother(z):
	var r = z
	if z > MAX_ZOOM:
		r = MAX_ZOOM + _smooth_func(z-MAX_ZOOM, 0.3)
	elif z < MIN_ZOOM:
		r = MIN_ZOOM - _smooth_func(MIN_ZOOM-z, 0.015)
	return r

func _smooth_func(x, h):
	return x*h/(x+h)