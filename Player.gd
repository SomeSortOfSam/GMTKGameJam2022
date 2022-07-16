extends Node3D

@onready var move_diffrence_timer : Timer = $MoveDiffrenceTimer
@onready var move_durration_timer : Timer = $MoveDurrationTimer

const MOVE_DISTANCE = .2
const GRID_EXTENTS := 4
const DIRECTION_MAP : Dictionary = {"ui_left" : Vector2i.LEFT,"ui_right" : Vector2i.RIGHT,"ui_up" : Vector2i.UP,"ui_down": Vector2i.DOWN}

@export var position_lerp_enabled := true
@export var time_to_rotate := .2

var last_direction := Vector2i(0,-1)
var queued_move : Vector2i
var current_cell := Vector2i(0,GRID_EXTENTS)

signal edge_reached(direction)

func _unhandled_input(event):
	for direction in DIRECTION_MAP:
		if event.is_action_pressed(direction):
			queued_move += DIRECTION_MAP[direction]
			if move_diffrence_timer.is_stopped():
				move_diffrence_timer.start()

func _process(delta):
	var percent_amount = delta/time_to_rotate
	if position_lerp_enabled:
		var target = Vector3(current_cell.x,0,current_cell.y) * MOVE_DISTANCE
		global_position = global_position.lerp(target,percent_amount)
	quaternion = quaternion.slerp(Quaternion.IDENTITY,percent_amount)

# returns true if the current cell changed
func set_current_cell(new_cell : Vector2i) -> bool:
	var new_direction = Vector2i.ZERO
	if abs(new_cell.x) > GRID_EXTENTS:
		new_direction = sign(new_cell.x)*Vector2i.RIGHT
	elif abs(new_cell.y) > GRID_EXTENTS:
		new_direction = sign(new_cell.y)*Vector2i.DOWN
	if new_direction != -last_direction:
		current_cell = new_cell
		if new_direction != Vector2i.ZERO:
			last_direction = new_direction
			move_durration_timer.start(time_to_rotate)
		return true
	return false

func _on_player_edge_reached(direction : Vector2i):
	current_cell.x = sign(direction.x)*GRID_EXTENTS if direction.x != 0 else current_cell.x
	current_cell.y = sign(direction.y)*GRID_EXTENTS if direction.y != 0 else current_cell.y
	position_lerp_enabled = false

func _on_cube_rotation_finished():
	position_lerp_enabled = true

func _on_move_diffrence_timer_timeout():
	if set_current_cell(current_cell + queued_move):
		var queued_rotation = -Vector2(queued_move)*(PI/2)
		global_rotate(Vector3.FORWARD,queued_rotation.x)
		global_rotate(Vector3.RIGHT,queued_rotation.y)
	else:
		global_rotate(Vector3.DOWN,.2)
	queued_move = Vector2i.ZERO

func _on_move_durration_timer_timeout():
	emit_signal("edge_reached",-last_direction)
