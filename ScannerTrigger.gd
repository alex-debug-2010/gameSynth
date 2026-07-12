extends Area2D

signal cutscene_started
signal cutscene_ended

var triggered = false

func _ready():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		cutscene_started.connect(player._on_cutscene_started)
		cutscene_ended.connect(player._on_cutscene_ended)

func _on_body_entered(body):
	if body.name == "Player" and not triggered:
		triggered = true
		start_cutscene()

func start_cutscene():
	var guard_label = get_node("../CanvasLayer/GuardLabel")
	var camera = get_node("../Camera2D")
	var guard = get_node("../Guard")  # "сюда объект охранника"
	
	# Текст охранника
	guard_label.text = "ОХРАННИК: Диспетчерская? Тут нарушитель. Жду группу."
	guard_label.visible = true
	
	# Запускаем кат-сцену
	cutscene_started.emit()
	
	# Камера приближается к охраннику
	await camera.cinematic_focus_object(
		guard,      # "сюда объект к которому приблизиться" (охранник)
		3.5,        # зум как у тебя был
		3.0         # "сюда время задержки" (смотрим на охранника 3 секунды)
	)
	
	# Завершаем кат-сцену
	_on_cutscene_end()

func _on_cutscene_end():
	var guard_label = get_node("../CanvasLayer/GuardLabel")
	var dex_label = get_node("../CanvasLayer/DexLabel")
	var guard = get_node("../Guard")  # "сюда охранник"
	var timer_label = get_node("../CanvasLayer/TimerLabel")
	var timer_gameover = get_node("../GameoverTimer")
	var timer_tick = get_node("/root/frame5/CanvasLayer/TickTimer")
	var camera = get_node("../Camera2D")
	var dex = get_node("../Dex")  # "сюда объект Декса" (если есть)
	
	# Текст Декса
	guard_label.visible = false
	dex_label.text = "ДЕКС: Да не..."
	dex_label.visible = true
	await get_tree().create_timer(1.5).timeout
	dex_label.visible = false
	
	# Запускаем таймер
	timer_gameover.start()
	
	timer_tick.get_node("/root/frame5/CanvasLayer/TickTimer/TickLabel").text = "125"
	timer_tick.get_node("/root/frame5/CanvasLayer/TickTimer/TickLabel").visible = true
	timer_tick.start()
	
	timer_label.visible = true
	timer_label.process_mode = Node.PROCESS_MODE_INHERIT
	#timer_label.set_process_input(true)
	
	# Прячем охранника
	guard.get_node("CollisionShape2D").disabled = true
	guard.get_node("ColorRect").visible = false
	
	# Если есть объект Декса, можно показать его
#	if dex:
#			dex,       # "сюда объект Декса"
#			3.5,
#			1.5        # "сюда время задержки"
#		)
#	else:
#		# Просто меняем зум как у тебя было
#		await camera.cinematic_zoom_to(1.0, 0.5)
	
	# Прячем текст Декса
	
	# Возвращаем камеру игроку
	await camera.cinematic_return_to_player()
	
	cutscene_ended.emit()

func mouse_1():
	var st = get_node("../ScannerTrigger")
	st.get_node("ColorRect").color = Color.YELLOW
	
func mouse_2():
	var st = get_node("../ScannerTrigger")
	st.get_node("ColorRect").color = Color.DARK_GOLDENROD	
	
	

	
	
