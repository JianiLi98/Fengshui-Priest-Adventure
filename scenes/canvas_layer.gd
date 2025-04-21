extends CanvasLayer

@export var spell_anim: AnimatedSprite2D
@export var line_container: Node2D
@export var spell_manager: Node

var is_drawing := false
var has_spell := false
var current_spell := "none"

const PADDING_X := 80.0
const PADDING_Y := 160.0

var current_line: Line2D = null
var all_points: Array[Vector2] = []

func _ready():
	hide()
	spell_anim.visible = false

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
		cast_spell()

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
	has_spell = true
	hide()
	current_spell = match_gesture(all_points)
	print("\u8bc6\u522b\u7ed3\u679c: ", current_spell)

func cast_spell():
	if spell_manager and current_spell != "unknown":
		var player = get_node("/root/Main/Player")
		var player_pos = player.global_position
		var facing_dir = player.call("get_facing_dir")
		spell_manager.call("cast", current_spell, player_pos, facing_dir)
	else:
		print("\u5f53\u524d\u672a\u51c6\u5907\u597d\u6280\u80fd")
	has_spell = false

func clear_line_container():
	for c in line_container.get_children():
		c.queue_free()

func match_gesture(points: Array[Vector2]) -> String:
	if points.size() < 2:
		return "unknown"

	var start = points[0]
	var end = points[-1]

	#if start.distance_to(end) < 20.0:
		#return "water"

	var stroke_count = line_container.get_child_count()
	match stroke_count:
		1: return "wind"
		2: return "fire"
		3: return "stone"
		4: return "water"
		_: return "unknown"
