extends Node3D

@onready var target_indicator : Node3D= $TargetIndicator
@onready var move_timer : Timer = $MoveTimer

const MOVE_DISTANCE = .2
const GRID_EXTENTS := 4
const DIRECTION_MAP : Dictionary = {"ui_left" : Vector2i.LEFT,"ui_right" : Vector2i.RIGHT,"ui_up" : Vector2i.UP,"ui_down": Vector2i.DOWN}

var last_move : Vector2i
var queued_move : Vector2i
var current_cell := Vector2i(0,-2)

func _unhandled_input(event):
	for direction in DIRECTION_MAP:
		if event.is_action_pressed(direction):
			queued_move += DIRECTION_MAP[direction]
			if move_timer.is_stopped():
				move_timer.start()
		#elif event.is_action_released(direction):
		#	queued_move -= DIRECTION_MAP[direction]

func _on_move_timer_timeout():
	translate(Vector3(queued_move.x * MOVE_DISTANCE,0,queued_move.y * MOVE_DISTANCE))
	queued_move = Vector2i.ZERO
