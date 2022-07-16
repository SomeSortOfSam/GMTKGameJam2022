extends Node3D

@onready var side_positions = $SidePositions
@onready var rotation_timer : Timer = $RotationTimer

@export var time_to_rotate := .2
@export var sides : Array[PackedScene]


var target_rotation : Quaternion
var current_side_template : Node3D
var current_side_index := 0

signal rotation_finished

func _process(delta):
	quaternion = quaternion.slerp(target_rotation,delta/time_to_rotate).normalized()

func get_current_side_parent() -> Node3D:
	return side_positions.get_child(0)

func get_current_side_number() -> int:
	return 1;

func get_next_side() -> Node3D:
	if not current_side_template:
		current_side_template = sides[current_side_index].instantiate()
	return current_side_template.duplicate()

func prepare_current_side():
	var side_parent = get_current_side_parent()
	for child in side_parent.get_children():
		side_parent.remove_child(child)
	var side = get_next_side()
	if side.has_method("prepared_side"):
		side.prepare_side(get_current_side_number())
		side_parent.add_child(side)
	

func _on_player_edge_reached(direction):
	var old_rotaiton = quaternion
	direction = direction * (PI/2)
	global_rotate(Vector3.FORWARD,direction.x)
	global_rotate(Vector3.RIGHT,direction.y)
	target_rotation = quaternion
	quaternion = old_rotaiton
	rotation_timer.start(time_to_rotate)
	prepare_current_side()

func _on_rotation_timer_timeout():
	emit_signal("rotation_finished")
