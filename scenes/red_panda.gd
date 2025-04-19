extends Area2D

signal rescued  # flag for main

func _on_body_entered(body):
	if body.name == "Player": 
		emit_signal("rescued")
		queue_free()  # remove panda if touched

func _ready():
	$AnimatedSprite2D.play("panda")
