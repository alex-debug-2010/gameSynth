extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
var boarded = false
func _on_body_entered(body):
	if boarded:
		return
	if body is CharacterBody2D and get_parent().is_ready:
		boarded = true
		print("Посадка!")
		get_parent().board()
