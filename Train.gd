extends Node2D

var player_inside = false
var is_ready = false
var my_y = 0
var my_x = 0

func _ready():
	visible = false
	my_y = position.y
	my_x = position.x

func call_train():
	position = Vector2(-600, my_y)
	visible = true
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", my_x, 2.0)
	
	await get_tree().create_timer(2.5).timeout
	is_ready = true

func board():
	if player_inside or not is_ready:
		return
	
	player_inside = true
	
	$/root/frame5/CanvasLayer/TickTimer.stop()
	
	var player = get_node("../Player")
	player.visible = false
	player.set_physics_process(false)
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)
	
	var camera = get_node("../Camera2D")
	
	get_node("../CanvasLayer/WinLabel").text = "ДЕКС ПРОШЁЛ!"
	get_node("../CanvasLayer/WinLabel").visible = true
	
	await get_tree().create_timer(1.5).timeout
	
	
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", 2500.0, 2.0)
	
	while position.x < 2500:
		camera.global_position.x = global_position.x
		await get_tree().process_frame
	
	var fade_rect = get_node("../CanvasLayer/FadeRect")
	fade_rect.visible = true
	var tween_fade = create_tween()
	tween_fade.tween_property(fade_rect, "color:a", 1.0, 1.5)
