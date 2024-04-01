extends Node2D

@onready var hitspot = $HitSpot
@onready var sprite = $Sprite2D

func _ready():
	SongEventBus.measure.connect(measure_occured)
	
func measure_occured(_current_measure):
	if sprite.visible:
		sprite.visible = false
	else:
		sprite.visible = true
