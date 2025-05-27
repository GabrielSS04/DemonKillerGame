extends Sprite2D

@onready var seta: Sprite2D = $"." 
@onready var area_2d: Area2D = $"../../Area2D"
@onready var villarger: CharacterBody2D = get_node("../../villarger")


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if villarger:
		var direction = villarger.global_position - global_position
		rotation = direction.angle() + deg_to_rad(90)
