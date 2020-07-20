extends Node

var SERVER_IP = '127.0.0.1'
var SERVER_PORT = 600

var peer = NetworkedMultiplayerENet.new()
var CLIENT_ID = -1

func _ready():
	get_tree().connect("connected_to_server", self, "connected_ok")
	get_tree().connect("connection_failed", self, "connected_fail")
	print('callbacks connected')

func _on_connect_button_pressed():
	get_tree().network_peer = null
	peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	CLIENT_ID = get_tree().get_network_unique_id()
	self.set_name(str(CLIENT_ID))
	print('connected to server, client_id:' + str(CLIENT_ID))
	
func send_number():
	rpc_id(1, "send_number", CLIENT_ID)

func connected_ok():
	print('connected to server')
		
func connected_fail():
	print('failed to connected to server')


func _on_send_value_pressed():
	print(get_path())
	send_number()
