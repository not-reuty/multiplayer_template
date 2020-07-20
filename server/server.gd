extends Node

var PORT = 600
var MAX_PLAYERS = 64

var peer = NetworkedMultiplayerENet.new()

func _ready():
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err == 0:
		print('server started, listening')
	get_tree().network_peer = peer
	
		
	var connected_success = get_tree().connect("network_peer_connected", self, "player_connected")
	var disconnected_success = get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	
	if connected_success or disconnected_success:
		print('something went wrong')
	
func player_connected(id):
	print('player ' + str(id) + ' connected')
	var newClient = load("res://remote_client.tscn").instance()
	newClient.set_name(str(id))
	add_child(newClient)
	
func player_disconnected(id):
	print('player ' + str(id) + ' disconnected')

