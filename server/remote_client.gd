extends Node

# This script holds the server's representation of a player.

var color = Color(randf(), randf(), randf(), 1)

func _ready():
	print('client created on server')
	
func initialise(new_color, new_position):
	print('client initialised on server')
	var id = int(name)
	print('client id: ' + str(id))
	$player/Sprite.modulate = new_color
	
	$player.position = new_position
	
	rpc_id(id, "initialise", [new_color, new_position])
	print('rpc call sent')
	
