extends Label

var current_beat = 0
var current_measure = 0

func _ready():
	SongEventBus.beat.connect(update_beat)
	SongEventBus.measure.connect(update_measure)
	
func _process(_delta):
	self.text = "Current Beat: %d\nCurrent Measure: %d" % [current_beat, current_measure]

func update_beat(beat):
	current_beat = beat
	
func update_measure(measure):
	current_measure = measure
