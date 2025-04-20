extends Node2D

func _on_red_panda_rescued():
	print("🎉 成功拯救小熊猫！")
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")  # 或显示提示
