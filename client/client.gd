extends Node

# networking variables
var SERVER_IP = '127.0.0.1'
var SERVER_PORT = 600

var peer = NetworkedMultiplayerENet.new()

# client side variables
var player = load("res://client_player.tscn")


func _ready():
	get_tree().connect("connected_to_server", self, "connected_ok")
	get_tree().connect("connection_failed", self, "connected_fail")
	print('callbacks connected')
	
	

func _on_connect_button_pressed():
	get_tree().network_peer = null
	peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	var id = get_tree().get_network_unique_id()
	self.set_name(str(id))
	print('connected to server, client_id:' + str(id))
	

remote func initialise(args):
	print('client initialised')
	print(args)
	# create a new client_player based on the return from the server
	var this_player = player.instance()
	this_player.position = args[1]
	this_player.modulate = args[0]
	add_child(this_player)
	

func connected_ok():
	print('connection ok')
		
func connected_fail():
	print('failed to connected to server')

