extends Node
@export var fire_spell_scene: PackedScene
@export var water_spell_scene: PackedScene
@export var wind_spell_scene: PackedScene
@export var stone_spell_scene: PackedScene

func cast(spell_name: String, player_pos: Vector2, facing_dir: Vector2):
	print("SpellManager.cast：", spell_name)

	var offset := facing_dir.normalized() * 64
	var spawn_pos = player_pos + offset

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
			push_error("unknown：" + spell_name)
			return

	var instance = spell_scene.instantiate()
	instance.global_position = spawn_pos
	add_child(instance)

	if instance.has_node("spell_anim"):
		var anim = instance.get_node("spell_anim") as AnimatedSprite2D
		anim.play(spell_name)
		print("animation：", anim.animation)

		await anim.animation_finished
		instance.queue_free()
	else:
		push_error("cannot play")
