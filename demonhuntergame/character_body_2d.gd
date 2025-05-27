extends CharacterBody2D

@onready var chat_colision: CollisionShape2D = $Area2D/chat_colision
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@onready var area_2d: Area2D = $"../Area2D"

const dialog_scene : PackedScene = preload("res://predicts/dialog_screen.tscn")

var dialog_data : Dictionary = {
	0: {"title": "Mãe", "dialog": "Bom dia meu filho, acordou cedo hoje!", "image": "res://sprites/npcs/mom_sprite.png"},
	1: {"title": "Mãe", "dialog": "Preciso de ajuda com algumas tarefas hoje...", "image": "res://sprites/npcs/mom_sprite.png"},
	2: {"title": "Mãe", "dialog": "Quero que você corte algumas lenha para podermos nos esquentar a noite!", "image": "res://sprites/npcs/mom_sprite.png"},
	3: {"title": "Mãe", "dialog": "Quando terminar, volte até mim!", "image": "res://sprites/npcs/mom_sprite.png"},
}

var dialog_data_2 : Dictionary = {
	0: {"title": "Mãe", "dialog": "Obrigado filho, essa lenha toda irá nós ajudar a sobreviver a este frio", "image": "res://sprites/npcs/mom_sprite.png"},
	1: {"title": "Mãe", "dialog": "Oh, seu irmão terminou de coletar os carvões perto da mina", "image": "res://sprites/npcs/mom_sprite.png"},
	2: {"title": "Mãe", "dialog": "Pegue o SACO DE CARVÃO perto da dispensa e leve a cidade para vender", "image": "res://sprites/npcs/mom_sprite.png"},
	3: {"title": "Mãe", "dialog": "Tome cuidado com a estrada, e volte antes do anoitecer!", "image": "res://sprites/npcs/mom_sprite.png"},
}

@export_category("object")
@export var hud : CanvasLayer = null

var can_chatting = false
var chating = false
var is_chop_wood: bool
var can_spaw_coal : bool = true

signal dialog_started
signal dialog_ended
signal dialog_one

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("chat") and can_chatting == true and !chating:
		var new_dialog = dialog_scene.instantiate()
		if is_chop_wood == false:
			new_dialog.data = dialog_data
			emit_signal("dialog_one")
		else:
			new_dialog.data = dialog_data_2
		hud.add_child(new_dialog)
		chating = true
		emit_signal("dialog_started")
		new_dialog.connect("dialog_ended", Callable(self, "_on_dialog_ended"))
		


func _on_dialog_ended() -> void:
	chating = false
	if is_chop_wood == true and can_spaw_coal == true:
		area_2d.visible = true
		can_spaw_coal = false
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


func _on_tronco_lenha_andar_player() -> void:
	is_chop_wood = true
