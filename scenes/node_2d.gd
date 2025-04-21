extends Node

# 这4个将从Inspector中绑定具体 .tscn 文件
@export var fire_spell_scene: PackedScene
@export var water_spell_scene: PackedScene
@export var wind_spell_scene: PackedScene
@export var stone_spell_scene: PackedScene

func cast(spell_name: String, player_pos: Vector2, facing_dir: Vector2):
	print("🔥 SpellManager.cast 被调用：", spell_name)

	var offset := facing_dir.normalized() * 64
	var spawn_pos = player_pos + offset

	# 1. 加载对应技能场景
	var spell_scene: PackedScene = null
	match spell_name:
		"fire":
			spell_scene = preload("res://scenes/fire.tscn")
		"wind":
			spell_scene = preload("res://scenes/wind.tscn")
		"water":
			spell_scene = preload("res://scenes/water.tscn")
		"stone":
			spell_scene = preload("res://scenes/stone.tscn")
		_:
			push_error("❌ 未知技能类型：" + spell_name)
			return

	# 2. 实例化并添加到场景
	var instance = spell_scene.instantiate()
	instance.global_position = spawn_pos
	add_child(instance)

	# 3. 播放动画（假设技能场景中有名为 spell_anim 的 AnimatedSprite2D）
	if instance.has_node("spell_anim"):
		var anim = instance.get_node("spell_anim") as AnimatedSprite2D
		anim.play(spell_name)
		print("✅ 动画播放中：", anim.animation)

		# 4. 等待动画播放完毕再销毁
		await anim.animation_finished
		instance.queue_free()
	else:
		push_error("❌ 找不到 spell_anim 节点，无法播放动画")
