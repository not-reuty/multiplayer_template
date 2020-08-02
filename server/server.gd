extends Node

var PORT = 600
var MAX_PLAYERS = 64

var tick_count = 0
var tickrate = 3

var peer = NetworkedMultiplayerENet.new()

func _ready():
	
	# start by setting the default values for the server
	Engine.iterations_per_second = tickrate
	
	
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err == 0:
		print('server started, listening on port ' + str(PORT) + ' for ' + str(MAX_PLAYERS) + ' max players')
	else:
		print("couldn't create server, stopping.")
		get_tree().quit()
		
	get_tree().network_peer = peer
	
	print('server id: ' + str(get_tree().get_network_unique_id()))
		
	var connected_success = get_tree().connect("network_peer_connected", self, "player_connected")
	var disconnected_success = get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	
	if connected_success or disconnected_success:
		print('connecting callbacks failed')
	
func player_connected(id):
	print('player ' + str(id) + ' connected')
	var player = load("res://player.tscn").instance()
	player.set_name(str(id))
	var new_player_color = Color(1,0,0,1)
	var new_player_position = Vector2(100,100)
	
	add_child(player)
	
	player.initialise(new_player_color, new_player_position)
	
	rpc_id(id, "initialise", [new_player_color, new_player_position])
	print('rpc call sent')
	
	
func player_disconnected(id):
	print('player ' + str(id) + ' disconnected')
	var remote_player = get_node(str(id))
	remote_player.queue_free()


func _on_restart_button_pressed():
	print('server restarted')
	get_tree().network_peer.close_connection()
	_ready()

func _on_tickrate_value_changed(value):
	print('tickrate changed to ' + str(value))
	Engine.iterations_per_second = value

remote func receive_data(id, data):
	var client = get_node(str(id))
	client.apply_input(data)

# using Godot's built in physics process as a tickrate
func _physics_process(delta):
	tick_count += 1
	var state = {'tick': tick_count}
	
	var player_states = {}
	var children = $players.get_children()
	for child in children:
		player_states[child.name] = {'position' : child.position}
	state['players'] = player_states
	
	rpc_unreliable("sync", state)
