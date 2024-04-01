extends HSlider

var target_value = 0

var left_side = true

var seconds_per_base_beat = 1

var tween: Tween

func _ready():
	SongEventBus.beat.connect(beat_occured)
	SongEventBus.seconds_per_base_beat.connect(set_seconds_per_base_beat)

func beat_occured(_beat_pos):
	tween = create_tween()
	if target_value == 0:
		target_value = 100
		tween.tween_property(self, "value", target_value, seconds_per_base_beat)
	elif target_value == 100:
		target_value = 0
		tween.tween_property(self, "value", target_value, seconds_per_base_beat)

func set_seconds_per_base_beat(seconds):
	seconds_per_base_beat = seconds
