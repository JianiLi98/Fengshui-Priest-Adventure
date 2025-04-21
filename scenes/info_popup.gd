extends PopupPanel
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		hide()
