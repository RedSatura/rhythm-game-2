extends HSlider

var target_value = 0

var left_side = true

var seconds_per_base_beat = 1

onready var tween = $Tween

func _ready():
	SongEventBus.connect("beat", self, "beat_occured")
	SongEventBus.connect("seconds_per_base_beat", self, "set_seconds_per_base_beat")

func beat_occured(_beat_pos):
	if target_value == 0:
		target_value = 100
		tween.interpolate_property(self, "value", self.value, target_value, seconds_per_base_beat, Tween.TRANS_LINEAR)
		tween.start()
	elif target_value == 100:
		target_value = 0
		tween.interpolate_property(self, "value", self.value, target_value, seconds_per_base_beat, Tween.TRANS_LINEAR)
		tween.start()

func set_seconds_per_base_beat(seconds):
	seconds_per_base_beat = seconds
