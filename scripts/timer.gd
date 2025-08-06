extends Label

var seconds_elapsed: float = 0

func _process(delta: float):
	if GameState.is_game_over:
		return
	seconds_elapsed += delta
	text = _format_seconds(seconds_elapsed, false)

func _format_seconds(time: float, use_milliseconds: bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]

	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
