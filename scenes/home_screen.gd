extends Control

func _ready():
	# 可选动画或提示
	print("Welcome to Fengshui Priest Adventure!")
	$AnimationPlayer.play("fade")
	$AnimationPlayer2.play("loop")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# 切换到主游戏场景
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
