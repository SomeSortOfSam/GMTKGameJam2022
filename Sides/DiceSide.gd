extends Node3D
class_name DiceSide

var death_timer : Timer

const PIP_DICTONARY := [[Vector2.ZERO],[Vector2.ONE,-Vector2.ONE],[Vector2.ONE,-Vector2.ONE,Vector2.ZERO],[Vector2.ONE,-Vector2.ONE,Vector2(-1,1),Vector2(1,-1)],[Vector2.ONE,-Vector2.ONE,Vector2(-1,1),Vector2(1,-1),Vector2.ZERO],[Vector2.ONE,-Vector2.ONE,Vector2(-1,1),Vector2(1,-1),Vector2.LEFT,Vector2.RIGHT]]

var turns_lived := 0
var scale_target := Vector3.ONE

func _ready():
	death_timer = Timer.new()
	death_timer.wait_time = .2
	death_timer.connect("timeout",_on_death_timer_timeout)
	add_child(death_timer)

func _process(delta):
	scale = scale.lerp(scale_target,delta/death_timer.wait_time)

func prepare_side(number : int ,previous_direction : Vector2):
	previous_direction.y *= -1
	rotate(basis.y,previous_direction.angle() + PI/2)
	scale *= .1

func place_one_on_each_pip(template : Node3D, number : int):
	for i in number:
		var pip = template.duplicate()
		var pip_place = PIP_DICTONARY[number-1][i]
		pip.position = (Vector3(pip_place.x,0,pip_place.y))*.6
		add_child(pip)

func on_cube_rotation_finished():
	if turns_lived > 1:
		scale_target = Vector3.ZERO
		death_timer.start() 
	else:
		turns_lived += 1

func _on_death_timer_timeout():
	queue_free()
