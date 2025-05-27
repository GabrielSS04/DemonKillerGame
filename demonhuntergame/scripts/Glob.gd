extends Node

var is_dialog_active: bool
var time : float = 220.0
var day_length : float = 800.0
var music_value: float
var current_music: String
var if_chop_wood : bool
var is_have_coalsack : bool = false
var entregou_coal : bool = false

var cut_scene_init : bool

func _process(delta: float) -> void:
	if !is_dialog_active or is_dialog_active:
		time += delta
		if time >= day_length:
			time = 0.0



func get_day_light_color() -> Color:
	var total_minutes = int((time / day_length) * 1440)
	var hour = total_minutes / 60
	var minute = total_minutes % 60
	var current_time = hour + (minute / 60.0)

	# DEFININDO AS CORES BASE
	var night = Color(0.15, 0.18, 0.25)
	var dawn = Color(1, 0.6, 0.4)
	var day = Color(1, 1, 1)
	var dusk = Color(0.4, 0.4, 0.6)

	if current_time >= 0 and current_time < 4:
		return night

	elif current_time >= 4 and current_time < 6:
		var t = (current_time - 4) / 2.0
		return night.lerp(dawn, t)

	elif current_time >= 6 and current_time < 9:
		var t = (current_time - 6) / 3.0
		return dawn.lerp(day, t)

	elif current_time >= 9 and current_time < 16:
		return day

	elif current_time >= 16 and current_time < 18:
		var t = (current_time - 16) / 2.0
		return day.lerp(dusk, t)

	elif current_time >= 18 and current_time < 22:
		var t = (current_time - 18) / 4.0
		return dusk.lerp(night, t)

	else:  # 22h até 00h (meia-noite)
		return night


func get_formatted_time() -> String:
	var total_minutes = int((time / day_length) * 1440)  # 1440 minutos = 24h
	total_minutes %= 1440

	var hour = total_minutes / 60
	var minute = total_minutes % 60
	return str(hour).pad_zeros(2) + ":" + str(minute).pad_zeros(2)
