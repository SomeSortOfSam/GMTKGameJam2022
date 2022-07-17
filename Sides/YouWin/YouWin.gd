extends DiceSide

signal requesting_disable_interface

func _ready():
	super()
	turns_lived = 1

func _on_pre_death():
	pass

func prepare_side(number : int ,direction : Vector2):
	emit_signal("requesting_disable_interface")

func _on_death_timer_timeout():
	get_tree().quit()
