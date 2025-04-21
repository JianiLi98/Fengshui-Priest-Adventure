extends AnimatedSprite2D

@export var scale_factor := 3.0
@export var fallback_lifetime := 1.2

var spell_name := ""

func set_spell_name(name: String):
	spell_name = name
	call_deferred("_play_spell")  # 确保在节点完全 ready 后播放

func _ready():
	scale = Vector2(scale_factor, scale_factor)
	z_index = 100
	modulate = Color(1, 1, 1, 1)  # 可自定义颜色，如 Color(1, 0.5, 0.5) 加红

func _play_spell():
	if spell_name != "" and sprite_frames and sprite_frames.has_animation(spell_name):
		print("🎬 播放动画:", spell_name)
		play(spell_name)
		await animation_finished
	else:
		print("⚠️ 播放失败: 没有动画 '", spell_name, "'，将等待 fallback 时间")
		await get_tree().create_timer(fallback_lifetime).timeout

	queue_free()
