extends Node3D
class_name DiceSide

var death_timer : Timer

@export var normal_pip_path : NodePath
@export var danger_pip_path : NodePath
@export_range(0.0,1.0,0.01) var danger_probibility : float
@export var color : Color
@export var blocked_path : NodePath

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

func prepare_side(number : int ,direction : Vector2):
	face_player(direction)
	clean_template_pips_and_place(number)

func face_player(direction : Vector2):
	direction.y *= -1
	rotate(basis.y,direction.angle() + PI/2)
	scale *= .1
	
func clean_template_pips_and_place(number : int):
	var normal_pip_template = get_node(normal_pip_path)
	var danger_pip_template = get_node(danger_pip_path)
	remove_child(normal_pip_template)
	remove_child(danger_pip_template)
	place_on_each_pip(normal_pip_template,danger_pip_template,number)
	normal_pip_template.queue_free()
	danger_pip_template.queue_free()

func place_on_each_pip(pip_template : Node3D, danger_template : Node3D, number : int):
	for i in number:
		var pip = pip_template.duplicate() if randf() > danger_probibility else danger_template.duplicate()
		var pip_place = PIP_DICTONARY[number-1][i]
		pip.position = (Vector3(pip_place.x,0,pip_place.y))*.6
		add_child(pip)

func on_cube_rotation_finished(_unused):
	if turns_lived > 1:
		_on_pre_death()
		death_timer.start() 
	else:
		turns_lived += 1

func _on_pre_death():
	scale_target = Vector3.ZERO

func _on_death_timer_timeout():
	queue_free()
