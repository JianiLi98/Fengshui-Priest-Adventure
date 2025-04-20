extends Node

@export var fire_anim: AnimatedSprite2D
@export var water_anim: AnimatedSprite2D
@export var wind_anim: AnimatedSprite2D
@export var stone_anim: AnimatedSprite2D

func cast(spell_name: String, player_pos: Vector2, facing_dir: Vector2):
	var offset := facing_dir.normalized() * 64
	var spawn_pos = player_pos + offset

	var anim: AnimatedSprite2D = null
	match spell_name:
		"fire": anim = fire_anim.duplicate()
		"water": anim = water_anim.duplicate()
		"wind": anim = wind_anim.duplicate()
		"stone": anim = stone_anim.duplicate()

	if anim:
		anim.global_position = spawn_pos
		get_tree().current_scene.add_child(anim)
		anim.play(spell_name)
		await get_tree().create_timer(1.0).timeout
		anim.queue_free()
