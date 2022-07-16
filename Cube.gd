extends Node3D

var target_rotation : Quaternion

func _process(delta):
	quaternion = quaternion.slerp(target_rotation,.1).normalized()

func _on_player_edge_reached(direction):
	var old_rotaiton = quaternion
	direction = direction * (PI/2)
	global_rotate(Vector3.FORWARD,direction.x)
	global_rotate(Vector3.RIGHT,direction.y)
	target_rotation = quaternion
	quaternion = old_rotaiton
	
