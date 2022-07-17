extends MeshInstance3D

@onready var label : Label3D = $Label3D

@export var rotations : Array[Quaternion]

var number := 1

func _on_cube_rotation_finished(new_accumulated_number):
	number = new_accumulated_number
	label.text = str(clamp(number,1,20))
