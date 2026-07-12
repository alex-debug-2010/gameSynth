extends Camera2D

@export var target : Node2D  # "сюда игрок" (твой Player)

# Настройки кинематографической камеры
@export var cinematic_smooth_speed: float = 4.0
@export var cinematic_zoom_speed: float = 3.0
@export var default_zoom: Vector2 = Vector2(1.0, 1.0)  # твой стандартный зум

var is_in_cutscene: bool = false
var cinematic_target: Node2D = null
var target_zoom: Vector2

func _ready():
	# Устанавливаем начальный зум
	zoom = default_zoom
	target_zoom = default_zoom

func _process(delta):
	if is_in_cutscene:
		# Кинематографическое движение
		if cinematic_target:
			global_position = global_position.lerp(cinematic_target.global_position, cinematic_smooth_speed * delta)
		zoom = zoom.lerp(target_zoom, cinematic_zoom_speed * delta)
	else:
		# Твоё обычное следование за игроком
		if target:
			global_position = target.global_position

# ============================================
# ФУНКЦИИ ДЛЯ КИНЕМАТОГРАФИЧЕСКОЙ КАМЕРЫ
# ============================================

# Приблизиться к объекту, задержаться, вернуться к игроку
func cinematic_focus_object(
	focus_target: Node2D,     # "сюда объект к которому приблизиться"
	zoom_level: float = 3.5,  # уровень зума (как у тебя в коде)
	hold_time: float = 0    # "сюда время задержки на объекте"
):
	is_in_cutscene = true
	cinematic_target = focus_target
	target_zoom = Vector2(zoom_level, zoom_level)
	
	# Ждём пока камера долетит
	await get_tree().create_timer(0.5).timeout
	
	# Держим камеру на объекте
	await get_tree().create_timer(hold_time).timeout  # "сюда время задержки"
	
	# Возвращаемся к игроку
	cinematic_return_to_player()

# Пролететь по нескольким объектам
func cinematic_sequence(
	objects: Array,           # "сюда массив объектов [охранник, дверь, терминал]"
	zoom_levels: Array = [],  # "сюда зумы для каждого [3.5, 4.0, 2.0]"
	hold_times: Array = []    # "сюда время показа для каждого [2.0, 1.5, 3.0]"
):
	is_in_cutscene = true
	
	for i in range(objects.size()):
		cinematic_target = objects[i]
		
		# Применяем зум если указан
		if i < zoom_levels.size():
			target_zoom = Vector2(zoom_levels[i], zoom_levels[i])
		
		await get_tree().create_timer(0.4).timeout
		
		# Держим если указано время
		var hold = hold_times[i] if i < hold_times.size() else 1.0
		await get_tree().create_timer(hold).timeout  # "сюда время задержки"
	
	cinematic_return_to_player()

# Тряска камеры
func cinematic_shake(intensity: float = 10.0, duration: float = 0.3):
	var original_pos = global_position
	var elapsed = 0.0
	
	while elapsed < duration:
		elapsed += get_process_delta_time()
		global_position = original_pos + Vector2(
			randf_range(-1, 1) * intensity,
			randf_range(-1, 1) * intensity
		)
		await get_tree().process_frame
	
	global_position = original_pos

# Мгновенный прыжок к объекту
func cinematic_snap(snap_target: Node2D, zoom_level: float = 3.5):
	"""
	Мгновенно телепортирует камеру
	snap_target - "сюда объект"
	"""
	global_position = snap_target.global_position
	zoom = Vector2(zoom_level, zoom_level)
	target_zoom = Vector2(zoom_level, zoom_level)

# Плавно изменить зум (без движения)
func cinematic_zoom_to(new_zoom: float = 3.5, duration: float = 0.5):
	target_zoom = Vector2(new_zoom, new_zoom)
	await get_tree().create_timer(duration).timeout

# Возврат к игроку и обычному режиму
func cinematic_return_to_player():
	"""
	Возвращает камеру к игроку и обычному режиму
	"""
	cinematic_target = target  # target - это твой игрок
	target_zoom = default_zoom
	await get_tree().create_timer(0.5).timeout
	is_in_cutscene = false

# Завершить кат-сцену экстренно
func cinematic_force_end():
	is_in_cutscene = false
	cinematic_target = target
	target_zoom = default_zoom
