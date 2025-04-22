extends PopupPanel

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		self.visible = false
		get_viewport().set_input_as_handled()
		get_node("/root/Main").info_opened_by_button = false

func _on_InfoPopup_popup_hide():
	get_node("/root/Main").info_opened_by_button = false
	call_deferred("reset_popup_state") 

func reset_popup_state():
	self.visible = false
