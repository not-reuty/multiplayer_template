extends Node

# This script holds the server's representation of a player.

var color = Color(randf(), randf(), randf(), 1)
var move_speed = 100

func _ready():
	print('client created on server')
	
func initialise(new_color, new_position):
	print('client initialised on server')
	var id = int(name)
	print('client id: ' + str(id))
	
	$Sprite.modulate = new_color
	self.position = new_position
	
	
func apply_input(data):
	
	for input in data:
		if input.has('left'):
			self.position.x -= move_speed * input['left']
		elif input.has('right'):
			self.position.x += move_speed * input['right']
			
