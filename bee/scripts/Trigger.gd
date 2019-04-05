extends Area2D

class_name Trigger

enum TriggerType { COMB, OPTION, BEE }

export(TriggerType) var _trigger_type

func _on_Trigger_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and !event.pressed:
			match _trigger_type:
				TriggerType.COMB:
					UIController.select_comb(event, get_parent(), get_parent().comb_type)
				TriggerType.OPTION:
					UIController.select_menu_option(event, get_parent().producer, get_parent().option_type)
				TriggerType.BEE:
					UIController.select_bee(event)