extends MeshInstance3D

@onready var label : Label3D = $Label3D
@onready var material : StandardMaterial3D = mesh.surface_get_material(0)

@export var rotations : Array[Quaternion]

const time_to_fade := 1
var number := 1
var enabled := false

func _process(delta):
	var target = Color(1,1,1,1) if enabled else Color(0,0,0,0)
	material.albedo_color = material.albedo_color.lerp(target,delta/time_to_fade)
	label.modulate = label.modulate.lerp(target,delta/time_to_fade)

func _on_cube_rotation_finished(new_accumulated_number):
	number = new_accumulated_number
	label.text = str(clamp(number,1,20))

func _on_cube_requesting_interface(new_enabled):
	enabled = new_enabled
