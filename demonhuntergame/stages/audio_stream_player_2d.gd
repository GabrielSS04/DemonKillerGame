extends AudioStreamPlayer2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.stream.loop = true
	audio_stream_player_2d.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
