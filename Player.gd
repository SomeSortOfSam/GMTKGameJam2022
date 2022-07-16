extends Node3D

@onready var move_timer : Timer = $MoveTimer

const MOVE_DISTANCE = .2
const GRID_EXTENTS := 4
const DIRECTION_MAP : Dictionary = {"ui_left" : Vector2i.LEFT,"ui_right" : Vector2i.RIGHT,"ui_up" : Vector2i.UP,"ui_down": Vector2i.DOWN}

var last_move : Vector2i
var queued_move : Vector2i
var current_cell := Vector2i(0,GRID_EXTENTS)

signal edge_reached(direction)

func _unhandled_input(event):
	for direction in DIRECTION_MAP:
		if event.is_action_pressed(direction):
			queued_move += DIRECTION_MAP[direction]
			if move_timer.is_stopped():
				move_timer.start()

func _process(delta):
	position = position.lerp(Vector3(current_cell.x,0,current_cell.y)*MOVE_DISTANCE,.1)
	position.clamp(Vector3.ONE*2,Vector3.ONE.ceil())
	rotation = Quaternion(rotation).slerp(Quaternion.IDENTITY,.1).get_euler()

func set_current_cell(new_cell : Vector2i):
	current_cell = new_cell
	if abs(current_cell.x) > GRID_EXTENTS:
		current_cell.x = -sign(current_cell.x)*GRID_EXTENTS
		emit_signal("edge_reached", sign(current_cell.x)*Vector2i.RIGHT)
	elif abs(current_cell.y) > GRID_EXTENTS:
		current_cell.y = -sign(current_cell.y)*GRID_EXTENTS
		emit_signal("edge_reached", sign(current_cell.y)*Vector2i.UP)

func _on_move_timer_timeout():
	var queued_rotation = -Vector2(queued_move)*(PI/2)
	rotate(Vector3.FORWARD,queued_rotation.x)
	rotate(Vector3.RIGHT,queued_rotation.y)
	set_current_cell(current_cell + queued_move)
	queued_move = Vector2i.ZERO

func _on_player_edge_reached(direction : Vector2i):
	position = Vector3(direction.x,0,-direction.y)*MOVE_DISTANCE*(GRID_EXTENTS+1)
