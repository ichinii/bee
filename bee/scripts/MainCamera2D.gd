extends Camera2D

const MIN_ZOOM = 0.1
const MAX_ZOOM = 2.0

var mobile = false
var zoom_value = 1.0

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
			self.offset -= event.relative * self.zoom.x * zfactor
	else:
		if event is InputEventMouseMotion and event.button_mask != 0:
			self.offset -= event.relative * self.zoom.x * zfactor

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
	
	# get_node("Label").text = str(contact_list.size())
	
	if _is_scrolling() or not mobile:
		_scroll(event)
	if _is_zooming():
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

func _process(delta):
	if not _is_zooming():
		_zoom_back()

	var view_zoom = _zoom_smoother(self.zoom_value)
	self.zoom.x = view_zoom
	self.zoom.y = view_zoom

	get_node("Label").text = str(view_zoom)

func _zoom_smoother(z):
	var r = z
	if z > MAX_ZOOM:
		r = MAX_ZOOM + _smooth_func(z-MAX_ZOOM, 0.3)
	elif z < MIN_ZOOM:
		r = MIN_ZOOM - _smooth_func(MIN_ZOOM-z, 0.015)
	return r

func _smooth_func(x, h):
	return x*h/(x+h)