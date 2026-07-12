extends CharacterBody2D

var speed = 250
var can_catch = false

func _ready():
	#print("EnforcerTemplate._ready")
	get_node("CatchZone").body_entered.connect(_on_catch)
	get_tree().create_timer(0.3).timeout.connect(
		func():
			can_catch = true
	)

func _physics_process(delta):
	velocity.x = speed
	velocity.y += 980 * delta
	#print("EnforcerTemplate._physics_process : ", self.name, " : ", velocity.x," , ", velocity.y)
	move_and_slide()

func _on_catch(body):
	#print("EnforcerTemplate._on_catch")
	if can_catch and body.name == "Player":
		get_node("../GameOver").game_over()

#код для энфорсеров
#var enforcers_spawned = false
#var enforcers_spawned2 = false
#enforcers_spawned = true
#if time_left <= 20 and not enforcers_spawned:
#			enforcers_spawned = true
#			spawn_enforcers()
#
#		if time_left <= 19.5 and not enforcers_spawned2 :
#			enforcers_spawned2 = true
#			spawn_enforcers2()	
#func spawn_enforcers():
#	var template = get_node("../../EnforcerTemplate")
#
#	var player = get_node("../../Player")
#
#	 #Охранник из пятерочки	1
#	var e = template.duplicate()
#	e.get_node("ColorRect").color = Color.YELLOW
#	e.process_mode = Node.PROCESS_MODE_INHERIT
#	e.global_position = player.global_position + Vector2(-400, -50)	
#	e.visible = true
#	get_node("../..").add_child(e)
#
##func spawn_enforcers2():
#	var template = get_node("../../EnforcerTemplate")	
#	var player = get_node("../../Player")

	# Охранник из пятерочки	2
#	var e1 = template.duplicate()
#	e1.get_node("ColorRect").color = Color.WEB_MAROON
#	e1.process_mode = Node.PROCESS_MODE_INHERIT	
#	e1.global_position = player.global_position + Vector2(-400, -50)
#	e1.visible = true
#	get_node("../..").add_child(e1)	


