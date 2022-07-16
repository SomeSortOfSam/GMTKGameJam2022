extends Node3D

@onready var sprite = $Sprite3D
@onready var death_timer : Timer = $DeathTimer

var turns_lived := 0
var scale_target := Vector3.ONE

func _process(delta):
	scale = scale.lerp(scale_target,delta/death_timer.wait_time)

func prepare_side(number,previous_direction):
	remove_child(sprite)
	previous_direction.y *= -1
	rotate(basis.y,previous_direction.angle() + PI/2)
	for i in number:
		var new_sprite = sprite.duplicate()
		new_sprite.position = Vector3.FORWARD * i/number *.8
		add_child(new_sprite)
	sprite.queue_free()
	scale *= .1

func on_cube_rotation_finished():
	if turns_lived > 1:
		scale_target = Vector3.ZERO
		death_timer.start() 
	else:
		turns_lived += 1

func _on_death_timer_timeout():
	queue_free()
