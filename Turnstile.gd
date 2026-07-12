extends StaticBody2D

var is_hacked = false
var hack_order = [2, 1, 3]
var player_input = []
var hacking = false
var hack_time_left = 7.0
var hack_timer_running = false

func interact():
	if is_hacked or hacking:
		return
	
	hacking = true
	player_input = []
	hack_time_left = 7.0
	hack_timer_running = true
	
	var hack_label = get_node("../CanvasLayer/HackLabel")
	hack_label.text = "ВЗЛОМ: нажми 2-1-3 | Осталось: 7"
	hack_label.visible = true

func _process(delta):
	if not hacking or not hack_timer_running:
		return
	
	hack_time_left -= delta
	var hack_label = get_node("../CanvasLayer/HackLabel")
	hack_label.text = "ВЗЛОМ: нажми 2-1-3 | Осталось: " + str(ceil(hack_time_left))
	
	if hack_time_left <= 0:
		hack_failed()
		return

func _input(event):
	if not hacking or not hack_timer_running:
		return
	
	if event is InputEventKey and event.pressed:
		var num = 0
		if event.keycode == KEY_1:
			num = 1
		elif event.keycode == KEY_2:
			num = 2
		elif event.keycode == KEY_3:
			num = 3
		
		if num > 0:
			check_input(num)

func check_input(num):
	player_input.append(num)
	
	var idx = player_input.size() - 1
	if player_input[idx] != hack_order[idx]:
		hack_failed()
		return
	
	if player_input.size() == 3:
		hack_success()

func hack_failed():
	player_input = []
	hack_time_left = 7.0
	
	var hack_label = get_node("../CanvasLayer/HackLabel")
	hack_label.text = "ОШИБКА! -3 сек. Нажми 2-1-3"
	
	var timer_label = get_node("../CanvasLayer/TimerLabel")
	add_penalty(3.0)
	
	hack_timer_running = false
	get_tree().create_timer(0.8).timeout.connect(
		func():
			hack_timer_running = true
	)
	
func add_penalty(amount):
	var timer_label = get_node("../CanvasLayer/TimerLabel")
	timer_label.time_left -= amount
	if timer_label.time_left <= 0:
		timer_label.text = "0"
		get_node("../GameOver").game_over()
		
func hack_success():
	hacking = false
	hack_timer_running = false
	
	var hack_label = get_node("../CanvasLayer/HackLabel")
	hack_label.text = "ТУРНИКЕТ ВЗЛОМАН!"
	await get_tree().create_timer(0.5).timeout
	hack_label.visible = false
	
	is_hacked = true
	queue_free()
	
	get_node("../Train").call_train()
