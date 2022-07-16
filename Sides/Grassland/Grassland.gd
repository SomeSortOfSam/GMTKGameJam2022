extends DiceSide

@onready var grass = $Grass

func prepare_side(number,previous_direction):
	super(number,previous_direction)
	remove_child(grass)
	place_one_on_each_pip(grass,number)
	grass.queue_free()

