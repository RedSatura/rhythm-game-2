extends AudioStreamPlayer

@export var bpm = 100
# base beats in a measure
@export var measures = 4
@export var exact_offset = 0
@export var beat_offset = 0

@export var base_beat = 1

var song_position = 0.0
var song_position_in_beats = 0
var seconds_per_base_beat = 1
var last_reported_beat = 0
var beats_before_start = 0
# current beat in measure
var measure = 1

var closest = 0
var time_off_beat = 0.0

func _ready():
	seconds_per_base_beat = 60.0 / bpm / base_beat
	if beat_offset > 0:
		measure += beat_offset
		exact_offset = beat_offset * seconds_per_base_beat
	play_song()

func _process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / seconds_per_base_beat)) + beats_before_start + beat_offset
		_report_beat()

func _report_beat():
	SongEventBus.emit_signal("seconds_per_base_beat", seconds_per_base_beat)
	if last_reported_beat < song_position_in_beats:
		if measure >= measures:
			measure = 0
			SongEventBus.emit_signal("measure", measures)
		SongEventBus.emit_signal("beat", song_position_in_beats)
		last_reported_beat = song_position_in_beats
		measure += 1
		
func closest_beat(nth):
	closest = int(round((song_position / seconds_per_base_beat) / nth) * nth) 
	time_off_beat = abs(closest * seconds_per_base_beat - song_position)
	return Vector2(closest, time_off_beat)
	
func play_from_beat(beat, offset_num):
	play_song()
	seek(beat * seconds_per_base_beat)
	beats_before_start = offset_num
	measure = beat % measures
	
func play_song():
	var effect = AudioServer.get_bus_effect(1, 0)
	if effect:
		effect.set_dry(0)
		effect.set_tap1_delay_ms(exact_offset)
		effect.set_tap2_active(false)
	
	measures *= base_beat
	
	play()

func _on_Conductor_finished():
	self.stop()
