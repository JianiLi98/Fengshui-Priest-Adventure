extends Node2D

@onready var info_popup := $CanvasLayer1/InfoPopup

func _unhandled_input(event):
	if event.is_action_pressed("open_info"):
		if info_popup.visible:
			info_popup.hide()
		else:
			info_popup.popup_centered()

func _on_red_panda_rescued():
	print("saved panda！")
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")  # 或显示提示
