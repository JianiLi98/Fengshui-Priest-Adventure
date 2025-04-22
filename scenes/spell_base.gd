extends AnimatedSprite2D

@export var auto_destroy := true

func _ready():
	if sprite_frames and not sprite_frames.has_animation("cast"):
		push_error("error！")
		return

	play("cast")

	if auto_destroy:
		await animation_finished
		queue_free()
