extends CharacterBody2D


@onready var player: CharacterBody2D = $"../Player"
@onready var animated_sprite_2d: Sprite2D = $sprite
@onready var chat_colision: CollisionShape2D = $Area2D/interag_colision

const dialog_scene : PackedScene = preload("res://predicts/dialog_screen.tscn")

var dialog_notCoal : Dictionary = {
	0: {"title": "Villager", "dialog": "Bom dia garoto, trouxe o meu carvão?", "image": "res://sprites/npcs/coal_buier.png"}
}

var dialog_data : Dictionary = {
	0: {"title": "Villager", "dialog": "Oh... Você me assustou", "image": "res://sprites/npcs/coal_buier.png"},
	1: {"title": "Villager", "dialog": "Como posso te ajudar garoto!", "image": "res://sprites/npcs/coal_buier.png"},
	2: {"title": "Villager", "dialog": "Ah, obrigado por me trazer o carvão, você salvou minha vida", "image": "res://sprites/npcs/coal_buier.png"},
	3: {"title": "Villager", "dialog": "Até mais garoto.", "image": "res://sprites/npcs/coal_buier.png"},
}

var dialog_data_2 : Dictionary = {
	0: {"title": "Villager", "dialog": "Obrigado por me trazer o carvão, atém ais garoto!", "image": "res://sprites/npcs/coal_buier.png"}
}

@export_category("object")
@export var hud : CanvasLayer = null

var can_chatting = false
var chating = false
var is_chat_count : bool = true

signal dialog_started
signal dialog_ended

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("chat") and can_chatting == true and !chating:
		var new_dialog = dialog_scene.instantiate()
		if Glob.is_have_coalsack:
			if is_chat_count == true:
				new_dialog.data = dialog_data
				is_chat_count = false
				Glob.entregou_coal = true
			else:
				new_dialog.data = dialog_data_2
		else:
			new_dialog.data = dialog_notCoal
		hud.add_child(new_dialog)
		chating = true
		emit_signal("dialog_started")
		new_dialog.connect("dialog_ended", Callable(self, "_on_dialog_ended"))
		


func _on_dialog_ended() -> void:
	chating = false
	
	emit_signal("conversou") 
	print("Diálogo finalizado, sinal 'conversou' emitido")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		can_chatting = true
		print("Pode falar")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		can_chatting = false
		chating = false
		print("Saiu, não pode falar")
