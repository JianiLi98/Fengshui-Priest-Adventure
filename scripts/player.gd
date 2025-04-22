extends CharacterBody2D

@export var speed := 200.0
@onready var anim := $AnimatedSprite2D
@onready var spell_canvas := get_node("CanvasLayer")

var facing_dir := Vector2.RIGHT  # \u9ed8\u8ba4\u671d\u53f3

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	direction = direction.normalized()

	if direction != Vector2.ZERO:
		# decide horizontal vs vertical
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
		
	velocity = direction * speed
	move_and_slide()

func get_facing_dir() -> Vector2:
	return facing_dir
	
func die():
	print("You died!")

	get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")


func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("ghosts") and spell_canvas.has_spell:
		if body.has_method("die"):
			body.die()
	
