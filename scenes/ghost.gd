extends CharacterBody2D

@export var speed: float = 100.0
@export var point_b: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var point_a: Vector2
var moving_to_b := true
var is_dead := false

func _ready():
	sprite.play("ghost")
	add_to_group("ghosts")
	point_a = global_position

func _physics_process(delta):
	if is_dead:
		return

	# 1. 选择目标点（GDScript 的 inline if 写法）
	var target: Vector2 = point_b if moving_to_b else point_a

	# 2. 向目标点移动
	var dir = (target - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	# 3. 简单“到达”检测，小于阈值就切换方向
	if moving_to_b and global_position.distance_to(point_b) < 2.0:
		moving_to_b = false
	elif not moving_to_b and global_position.distance_to(point_a) < 2.0:
		moving_to_b = true

func die():
	if is_dead:
		return
	is_dead = true
	sprite.play("die")
	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false
	await sprite.animation_finished
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not is_dead:
		if body.has_method("die"):
			body.die()
