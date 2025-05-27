extends CharacterBody2D

const SPEED = 60.0
const RUN_SPEED = 300.0
const COOLDOWN_TIME = 0.3  # Tempo de cooldown em segundos

@onready var texture: AnimatedSprite2D = $AnimatedSprite2D
@onready var cut_scene: AnimationPlayer = $"../cut_scene"
@onready var timer_cortar_lenha: Timer = $"../Timer-cortarLenha"
@onready var area_2d: Area2D = $"../Area2D"

@export_category("object")
@export var hud : CanvasLayer = null

const dialog_scene : PackedScene = preload("res://predicts/dialog_screen.tscn")

var dialog_not_chop : Dictionary = {
	0: {"title": "Ryoga", "dialog": "Melhor eu ver oque a mamãe quer primeiro!", "image": "res://sprites/npcs/mom_sprite.png"},
}

var dialog_not_coal : Dictionary = {
	0: {"title": "Ryoga", "dialog": "Quase esqueci, tenho que pegar o carvão para levar na cidade!", "image": "res://sprites/npcs/mom_sprite.png"},
}

var last_direction: Vector2 = Vector2(0, 1)
var is_attacking: bool = false
var is_menu_open: bool = false
var is_hav_coal: bool = false

var parar_player : bool

func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	
	if parar_player == true:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if cut_scene.is_playing() or is_menu_open or Glob.is_dialog_active:        
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Movimentação do personagem
	var direction: Vector2 = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var current_speed = SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = RUN_SPEED
	velocity = direction * current_speed

	move_and_slide()

	# Verificando a direção do movimento
	if direction.length() > 0:
		last_direction = direction.normalized()

	# Controle das animações de movimento
	if velocity.x > 0:
		texture.play("walking_right")
	elif velocity.x < 0:
		texture.play("walking_left")
	elif velocity.y > 0:
		texture.play("walking_down")
	elif velocity.y < 0:
		texture.play("walking_up")
	else:
		match last_direction:
			Vector2(0, 1):
				texture.play("idle_down")
			Vector2(0, -1):
				texture.play("idle_up")
			Vector2(1, 0):
				texture.play("idle_right")
			Vector2(-1, 0):
				texture.play("idle_left")

func attack() -> void:
	if not is_attacking:
		is_attacking = true
		match last_direction:
			Vector2(0, 1):
				texture.play("attack_down")
			Vector2(0, -1):
				texture.play("attack_up")
			Vector2(1, 0):
				texture.play("attack_right")
			Vector2(-1, 0):
				texture.play("attack_left")

		texture.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))

func _on_attack_animation_finished() -> void:
	is_attacking = false
	match last_direction:
		Vector2(0, 1):
			texture.play("idle_down")
		Vector2(0, -1):
			texture.play("idle_up")
		Vector2(1, 0):
			texture.play("idle_right")
		Vector2(-1, 0):
			texture.play("idle_left")

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attack()

func _on_menu_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "menu_open":
		is_menu_open = true
	elif anim_name == "menu_close":
		is_menu_open = false



func _on_tronco_lenha_parar_player() -> void:
	parar_player = true


func _on_tronco_lenha_andar_player() -> void:
	parar_player = false


func _on_menupause_salvar_game() -> void:
	SaveManager.set_player(self)


func _on_area_2d_coletado() -> void:
	is_hav_coal = true
	Glob.is_have_coalsack = true
	Glob.entregou_coal = false


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	self.position.x += 10
	if body == self:
		if Glob.if_chop_wood == false:
			var new_dialog = dialog_scene.instantiate()
			new_dialog.data = dialog_not_chop
			hud.add_child(new_dialog)
			emit_signal("dialog_started")
		elif is_hav_coal == false:
			var new_dialog = dialog_scene.instantiate()
			new_dialog.data = dialog_not_coal
			hud.add_child(new_dialog)
			emit_signal("dialog_started")
