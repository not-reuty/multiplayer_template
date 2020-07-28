extends Node

remote func sync(state):
	print(state)
	var id = get_tree().get_network_unique_id()
	
	var client = get_node(str(id))
	var current_position = client.get_node('player').position
	
	rpc_unreliable_id(1, 'receive_data', id, [current_position])

