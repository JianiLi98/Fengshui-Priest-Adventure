extends Node2D

func _ready():
	$CanvasLayer1/InfoButton.pressed.connect(_on_info_button_pressed)

func _on_info_button_pressed():
	$CanvasLayer1/InfoPopup.popup_centered()

func _on_red_panda_rescued():
	print("🎉 成功拯救小熊猫！")
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")  # 或显示提示
