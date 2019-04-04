extends Area2D

class_name Trigger

enum TriggerType { COMB, OPTION }

export(TriggerType) var trigger_type

func _on_Trigger_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and !event.pressed:
			var option_id = -1
			if get_parent().get("option") != null:
				option_id = get_parent().option
				
			UIController.trigger_pressed(event, trigger_type, option_id)