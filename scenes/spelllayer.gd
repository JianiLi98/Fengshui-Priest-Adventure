extends Node

@export var fire_spell_scene: PackedScene
@export var water_spell_scene: PackedScene
@export var wind_spell_scene: PackedScene
@export var stone_spell_scene: PackedScene

var current_spell_instance: Node2D = null  # 当前 spell 场景
var current_spell: String = "none"         # 通过画符识别得到的 spell 名称

func _input(event):
	# 按下空格开始识别（测试用，可替换为你画符识别逻辑）
	if event.is_action_pressed("draw_spell"):
		current_spell = match_gesture()
		print("🪄 识别结果：", current_spell)

	# 按下 Q（或你自定义的释放键）释放当前 spell
	if event.is_action_pressed("cast_spell") and current_spell != "none":
		print("✨ 释放技能：", current_spell)
		show_spell(current_spell)
		current_spell = "none"

# 替换为你自己的识别逻辑
func match_gesture() -> String:
	# 假设外部传入了识别结果（可自行替换为实际画符逻辑）
	return "fire"  # 示例用，实际可由画符系统更新 current_spell

# 播放对应 spell 动画场景
func show_spell(spell_name: String):
	if current_spell_instance:
		current_spell_instance.queue_free()
		current_spell_instance = null

	var scene: PackedScene = null
	match spell_name:
		"fire": scene = fire_spell_scene
		"water": scene = water_spell_scene
		"wind": scene = wind_spell_scene
		"stone": scene = stone_spell_scene
		_: 
			push_error("❌ 未知 spell 名称：" + spell_name)
			return

	current_spell_instance = scene.instantiate()
	add_child(current_spell_instance)

	var viewport_size = get_viewport().get_visible_rect().size
	current_spell_instance.global_position = viewport_size / 2.0

	if current_spell_instance is AnimatedSprite2D:
		current_spell_instance.play("cast")
	elif current_spell_instance.has_node("AnimatedSprite2D"):
		var anim = current_spell_instance.get_node("AnimatedSprite2D") as AnimatedSprite2D
		anim.play("cast")
