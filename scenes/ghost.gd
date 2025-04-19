# ghost.gd
# 让鬼魂在地图可通行区域内随机漫游并自动绕开障碍

extends CharacterBody2D

@export var speed := 100.0

# 存放当前要漫游到的目标点
var target: Vector2

func _ready():
	randomize()                        # 不同运行随机不同
	$AnimatedSprite2D.play("ghost")   # 播放鬼魂动画
	_pick_new_target()                 # 刚开始就选个地方去
	
func _physics_process(delta):
	# 到达当前目标则重新选
	if global_position.distance_to(target) < 8:
		_pick_new_target()

	# 通知导航组件去 target
	$NavigationAgent2D.target_position = target

	# 如果导航没结束，就继续往下一个导航点移动
	if not $NavigationAgent2D.is_navigation_finished():
		var next_point = $NavigationAgent2D.get_next_path_position()
		velocity = (next_point - global_position).normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _pick_new_target():
	# 1. 拿到场景中的 TileMap
	var tm = get_tree().get_current_scene().get_node("TileMap") as TileMap
	# 2. 获取已使用的瓦片矩形（tile 单位）
	var used = tm.get_used_rect()
	# 3. 在该矩形范围内随机选一个格子坐标
	var cell_x = randi_range(used.position.x, used.position.x + used.size.x - 1)
	var cell_y = randi_range(used.position.y, used.position.y + used.size.y - 1)
	var cell = Vector2i(cell_x, cell_y)
	# 4. 把格子坐标转换成世界坐标，作为新的目标
	#    map_to_world 返回的是该瓦片左上角位置
	var tile_size = tm.tile_set.tile_size
	target = cell * tile_size
	print("👻 Ghost new target:", target)
	

func _on_area_2d_body_entered(body: Node2D): 
	if body.name == "Player":
		print("👻 玩家被鬼魂抓住！")
		get_tree().change_scene_to_file("res://scenes/LoseScreen.tscn")
		
