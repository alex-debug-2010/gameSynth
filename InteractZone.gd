extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		body.can_interact = true
		body.current_interactable = get_parent()

func _on_body_exited(body):
	if body.name == "Player":
		body.can_interact = false
		body.current_interactable = null
