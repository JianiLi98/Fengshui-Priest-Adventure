extends CharacterBody2D

@export var speed := 200.0
@onready var anim := $AnimatedSprite2D

var facing_dir := Vector2.RIGHT  # \u9ed8\u8ba4\u671d\u53f3

func _physics_process(delta):
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	velocity = direction * speed

	# \u8bbe\u7f6e facing_dir
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			facing_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		else:
			facing_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP

	# \u52a8\u753b\u64ad\u653e
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			anim.play("walk_right") if direction.x > 0 else anim.play("walk_left")
		else:
			anim.play("walk_down") if direction.y > 0 else anim.play("walk_up")
	else:
		anim.stop()

	move_and_slide()

func get_facing_dir() -> Vector2:
	return facing_dir
