extends CharacterBody2D

var speed = 200
var walk_speed = 200
var run_speed = 400
var can_interact = false
var current_interactable = null
var can_move = true
var decelerating = false
func _ready():
	# Начальная катсцена: Декс выходит слева
	position = Vector2(-1000, 89)
	var tween = create_tween()
	
	tween.tween_property(self, "position:x", -900, 1.5)
func _physics_process(delta):
	if not can_move:
		if decelerating:
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			if abs(velocity.x) < 5:
				velocity.x = 0
				decelerating = false
		else:
			velocity.x = 0
		move_and_slide()
		return
	
	var direction = 0
	
	if Input.is_action_pressed("ui_accept"):
		speed = run_speed
	else:
		speed = walk_speed
	
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	
	velocity.x = direction * speed
	velocity.y += 980 * delta
	move_and_slide()

func _input(event):
	if not can_move:
		return
	if event.is_action_pressed("interact") and can_interact and current_interactable:
		current_interactable.interact()

func _on_cutscene_started():
	can_move = false
	decelerating = true

func _on_cutscene_ended():
	can_move = true
	decelerating = false

	


func _on_interact_zone_2_body_entered(body):
	pass # Replace with function body.


func _on_interact_zone_2_body_exited(body):
	pass # Replace with function body.
