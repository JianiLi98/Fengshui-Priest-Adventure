extends Node

@export var spell_scene: PackedScene  # 指向 Spell.tscn

func cast(spell_name: String, origin: Vector2, direction: Vector2):
	if spell_scene == null:
		print("⚠️ Spell scene not assigned!")
		return

	var spell_instance = spell_scene.instantiate()
	get_tree().current_scene.add_child(spell_instance)

	spell_instance.global_position = origin
	spell_instance.rotation = direction.angle()
	
	# 告诉动画播放哪个 spell
	spell_instance.play(spell_name)
