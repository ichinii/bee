extends Node

func is_mobile() -> bool:
	match OS.get_name():
		"Android", "iOS":
			return true
		"Haiku", "HTML5", "OSX", "Server", "Windows", "UWP", "X11", _:
			return false

func get_touch_event_type():
	if DeviceHelper.is_mobile():
		return InputEventScreenTouch
	return InputEventMouseButton