extends Node


# ==== BASIC CLIENT TEMPLATE ====
# This client needs to be able to do 3 core things;
# 1. connect to a server
# 2. send data about itself to that server
# 3. receive data about the state of the game (and update its children)

# To do this, 


var SERVER_IP = '127.0.0.1'
var SERVER_PORT = 600
var CLIENT_ID = 0

var peer = NetworkedMultiplayerENet.new()
var player = load("res://player.tscn")


var action_queue = []

func add_action(action):
	action_queue.append(action)


	
func connected_ok():
	CLIENT_ID = get_tree().get_network_unique_id()
	print('connected to server, id: ' + str(CLIENT_ID))
		
func connected_fail():
	print('failed to connected to server')

func _ready():
	get_tree().connect("connected_to_server", self, "connected_ok")
	get_tree().connect("connection_failed", self, "connected_fail")
	print('callbacks connected')


func _on_connect_button_pressed():
	get_tree().network_peer = null
	peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	

remote func initialise(args):
	print('client initialised')
	print(args)
	# create a new player based on the return from the server
	var this_player = player.instance()
	this_player.position = args[1]
	this_player.modulate = args[0]
	this_player.name = str(CLIENT_ID)
	add_child(this_player)

# get any changes from this client and send them to the server
remote func sync(state):
		
	var player = get_node(str(CLIENT_ID))
	# update client's player position
	var player_data = state['players']
	print(player_data)
	if player_data.has(str(CLIENT_ID)):
		player.position = player_data[str(CLIENT_ID)]['position']
	
	if len(action_queue) == 0:
		return
	else:
		rpc_unreliable_id(1, 'receive_data', CLIENT_ID, action_queue)
		action_queue = []


var speed = 100 # pixels per second

func _physics_process(delta):
	
	if Input.is_action_pressed("move_left"):
		add_action({'left': delta})
		
	if Input.is_action_pressed("move_right"):
		add_action({'right': delta})
		















