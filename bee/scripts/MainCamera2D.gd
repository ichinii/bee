extends Camera2D

var mobile = false

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
	if mobile:
		if event is InputEventScreenDrag:
			self.offset -= event.relative * self.zoom.x
	else:
		if event is InputEventMouseMotion and event.button_mask != 0:
			self.offset -= event.relative * self.zoom.x

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
		self.zoom.x *= zoom_factor
		self.zoom.y *= zoom_factor
		get_node("Label").text = str(self.zoom.x)

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