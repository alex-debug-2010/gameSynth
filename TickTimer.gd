extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	var full_path = self.get_path()
	print(full_path)
	print("приветnnnnn")
	
func _on_timeout():
	get_node("TickLabel").text = str(int(get_node("TickLabel").text) - 1)
