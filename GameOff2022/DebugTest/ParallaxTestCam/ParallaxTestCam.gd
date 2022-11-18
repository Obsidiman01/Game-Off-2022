extends Camera2D

func _ready():
	
	current = true


func _process(_delta):
	
	position.x += 1
	position.y = 100*sin(position.x/100)
	
