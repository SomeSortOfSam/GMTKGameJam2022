extends Node3D
class_name DiceSide

var death_timer : Timer

var turns_lived := 0
var scale_target := Vector3.ONE

func _ready():
	death_timer = Timer.new()
	death_timer.wait_time = .2
	death_timer.connect("timeout",_on_death_timer_timeout)
	add_child(death_timer)

func _process(delta):
	scale = scale.lerp(scale_target,delta/death_timer.wait_time)

func prepare_side(number,previous_direction):
	previous_direction.y *= -1
	rotate(basis.y,previous_direction.angle() + PI/2)
	scale *= .1

func on_cube_rotation_finished():
	if turns_lived > 1:
		scale_target = Vector3.ZERO
		death_timer.start() 
	else:
		turns_lived += 1

func _on_death_timer_timeout():
	queue_free()
