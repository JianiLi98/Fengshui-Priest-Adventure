extends CanvasLayer

@export var spell_anim: AnimatedSprite2D
@export var line_container: Node2D
@onready var player := get_node("/root/Main/Player")

var spell_manager: Node = null
var is_drawing := false
var has_spell := false
var current_spell := "none"

const PADDING_X := 80.0
const PADDING_Y := 160.0

var current_line: Line2D = null
var all_points: Array[Vector2] = []

@onready var spell_popup_label := get_node("/root/Main/SpellPopupLayer/SpellPopupLabel")


func _ready():
	hide()
	spell_anim.visible = false

	# ⚠️ 修改为你实际场景中 SpellManager 节点的路径
	if has_node("/root/Main/SpellManager"):
		spell_manager = get_node("/root/Main/SpellManager")
	else:
		push_error("not found SpellManager")

func _input(event):
	
	if event.is_action_pressed("draw_spell") and not is_drawing and not has_spell:
		start_drawing()

	elif is_drawing:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			current_line = Line2D.new()
			current_line.width = 20
			current_line.default_color = Color.WHITE
			line_container.add_child(current_line)

		elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if current_line:
				var mouse_pos = get_viewport().get_mouse_position()
				var frame = spell_anim.frame
				var texture = spell_anim.sprite_frames.get_frame_texture("open", frame)
				var size = texture.get_size() * spell_anim.scale
				var top_left = spell_anim.global_position - (size / 2.0)
				var draw_area = Rect2(top_left + Vector2(PADDING_X, PADDING_Y), size - Vector2(PADDING_X * 2, PADDING_Y * 2))
				if draw_area.has_point(mouse_pos):
					var local_point = current_line.to_local(mouse_pos)
					current_line.add_point(local_point)
					all_points.append(local_point)

		elif event.is_action_pressed("end_draw"):
			finish_drawing()

	elif has_spell and event.is_action_pressed("cast_spell"):
		print("Q releases spell：", current_spell)

		if not is_instance_valid(spell_manager):
			push_error("spell_manager not found")
			return

		var cast_position = Vector2(600, 400) 
		var cast_direction = Vector2(1, 0) 

		spell_manager.call("cast", current_spell, cast_position, cast_direction)

		has_spell = false
		current_spell = "none"

func start_drawing():
	is_drawing = true
	show()
	spell_anim.visible = true
	spell_anim.stop()
	spell_anim.frame = 0
	spell_anim.play("open")
	all_points.clear()
	clear_line_container()
	current_line = null
	current_spell = "none"

func finish_drawing():
	is_drawing = false
	hide()
	current_spell = match_gesture(all_points)
	print("🪄 识别结果: ", current_spell)

	has_spell = true

	# ✨ 第一步：展示画了什么符咒
	await show_spell_popup("You drew: %s spell!" % current_spell.capitalize())

	# ✨ 第二步：判断攻击范围内是否有鬼
	var attack_area = player.get_node("AttackArea")
	var ghosts_killed := false

	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("ghosts") and body.has_method("die"):
			body.die()
			ghosts_killed = true

	# ✨ 第三步：根据是否成功杀鬼展示不同提示
	if ghosts_killed:
		await show_spell_popup("✅ Killed with %s spell!" % current_spell.capitalize())
	else:
		await show_spell_popup("❌ No ghost nearby.")

	# 重置状态
	has_spell = false
	current_spell = "none"

func clear_line_container():
	for c in line_container.get_children():
		c.queue_free()

func match_gesture(points: Array[Vector2]) -> String:
	if points.size() < 2:
		
		return "unknown"

	var start = points[0]
	var end = points[-1]


	var stroke_count = line_container.get_child_count()
	match stroke_count:
		1: return "wind"
		2: return "fire"
		3: return "stone"
		4: return "water"
		_: return "unknown"
		
	
func show_spell_popup(message: String) -> void:
	if not spell_popup_label:
		push_error("Label not found")
		return

	spell_popup_label.text = message
	spell_popup_label.visible = true
	await get_tree().create_timer(1.5).timeout
	spell_popup_label.visible = false


	
