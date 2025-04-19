extends CharacterBody2D

@export var speed := 200.0
@onready var anim := $AnimatedSprite2D

func _physics_process(delta):
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	velocity = direction * speed

	# directions
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_right")
			else:
				anim.play("walk_left")
		else:
			if direction.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")
	else:
		anim.stop()

	move_and_slide()
