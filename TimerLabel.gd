extends Label
signal time_reached
signal time_gameover(messag)
var time_left: float = 25.0

func _process(delta):
	time_left -= delta
	text = str(ceil(time_left))
	if time_left <= 5: 
		
		time_reached.emit(5)
	if time_left <= 20:
		time_gameover.emit("By-by ...")
