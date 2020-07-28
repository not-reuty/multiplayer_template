extends Area2D

var speed = 100 # pixels per second

func _physics_process(delta):
	
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
		
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta 
