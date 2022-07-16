extends Node3D

@onready var rotation_timer : Timer = $RotationTimer
@onready var material : StandardMaterial3D = $Cube.mesh.surface_get_material(0)

@export var time_to_rotate := .2
@export var sides : Array[PackedScene]

const NORMALS_TO_NUMBERS := {Vector3i.UP:1,Vector3i.DOWN:6,Vector3i.LEFT:2,Vector3i.RIGHT:5,Vector3i.FORWARD:4,Vector3i.BACK:3}

var target_rotation : Quaternion
var target_color : Color
var current_side_template : DiceSide
var current_side_index := -1
var aculatted_number := 0

signal rotation_finished

func _ready():
	prepare_current_side(Vector2.DOWN).turns_lived = 1

func _process(delta):
	quaternion = quaternion.slerp(target_rotation,delta/time_to_rotate).normalized()
	material.albedo_color = material.albedo_color.lerp(target_color,delta/time_to_rotate)

func get_current_side_number() -> int:
	return NORMALS_TO_NUMBERS[Vector3i(basis.z.round())];

func get_next_side() -> Node3D:
	if (aculatted_number > 20 or not current_side_template) and len(sides) > current_side_index + 1:
		current_side_index += 1
		aculatted_number
		current_side_template = sides[current_side_index].instantiate()
		target_color = current_side_template.color
	return current_side_template.duplicate()

func prepare_current_side(direction: Vector2) -> Node3D:
	var side = get_next_side()
	if side.has_method("prepare_side"):
		var number = get_current_side_number()
		side.call_deferred("prepare_side",number,direction)
		aculatted_number += get_current_side_number()
		connect("rotation_finished",side.on_cube_rotation_finished)
		add_child(side)
		side.global_rotation = Vector3.ZERO
		side.global_position = Vector3.DOWN * .09
	return side
	

func _on_player_edge_reached(direction : Vector2):
	var old_rotaiton = quaternion
	direction = direction * (PI/2)
	global_rotate(Vector3.FORWARD,direction.x)
	global_rotate(Vector3.RIGHT,direction.y)
	target_rotation = quaternion
	prepare_current_side(direction/(PI/2))
	quaternion = old_rotaiton
	rotation_timer.start(time_to_rotate)

func _on_rotation_timer_timeout():
	emit_signal("rotation_finished")
