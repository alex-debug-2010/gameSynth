extends Node2D

func _ready():
	var timer_gameover = get_node("../GameoverTimer")
	timer_gameover.timeout.connect(_on_time_gameover)
	#var timer = get_node("../CanvasLayer/TimerLabel")
	#timer.time_gameover.connect(_on_time_gameover)

func _on_time_gameover():
	print("Message : By-by ...")
	game_over()

func game_over():
	$/root/frame5/CanvasLayer/TickTimer.stop()
	
	var fail_label = get_node("../CanvasLayer/FailLabel")
	fail_label.text = "ПАТРУЛЬ ПРИБЫЛ"
	fail_label.visible = true
	
	var color_rect = get_node("../CanvasLayer/FadeRect")
	color_rect.visible = true
	
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, 1.0)
	
	get_tree().create_timer(3.0).timeout.connect(
		func():
			get_tree().reload_current_scene()
	)
	
