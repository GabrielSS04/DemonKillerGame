extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var sound_colect: AudioStreamPlayer2D = $"../sound_colect"

signal coletado

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body == player:
		sound_colect.play()
		emit_signal("coletado")
		Glob.is_have_coalsack = true
		
		
		queue_free()
