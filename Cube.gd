extends Node3D

func _process(delta):
	rotation = Quaternion(rotation).slerp(Quaternion.IDENTITY,.1).get_euler()

func _on_player_edge_reached(direction):
	var queued_rotation = -Vector2(direction)*(PI/2)
	rotate(Vector3.FORWARD,queued_rotation.x)
	rotate(Vector3.RIGHT,queued_rotation.y)
