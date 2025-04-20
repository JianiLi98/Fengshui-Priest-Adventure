extends CharacterBody2D

@export var speed := 150.0
@onready var anim := $AnimatedSprite2D

var facing_dir := Vector2.RIGHT  # 默认朝右

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		facing_dir = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		facing_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1
		facing_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
		facing_dir = Vector2.DOWN

	# 设置速度（Godot 4 中必须设置 velocity）
	velocity = direction.normalized() * speed

	# 动画播放
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			anim.play("walk_right") if direction.x > 0 else anim.play("walk_left")
		else:
			anim.play("walk_down") if direction.y > 0 else anim.play("walk_up")
	else:
		anim.stop()

	# 调用 Godot 4 的移动函数（不传参数）
	move_and_slide()
