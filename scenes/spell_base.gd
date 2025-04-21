extends AnimatedSprite2D

@export var auto_destroy := true  # 是否在动画播放结束后自动销毁

func _ready():
	if sprite_frames and not sprite_frames.has_animation("cast"):
		push_error("❌ 当前动画缺少 'cast' 动画段！")
		return

	play("cast")

	if auto_destroy:
		await animation_finished
		queue_free()
