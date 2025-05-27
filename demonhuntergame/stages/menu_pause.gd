extends Control

@onready var menu_anim: AnimationPlayer = $"../../menu_anim"
@onready var menu_pause: Control = $"."

signal salvar_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_pause.position.y = 850


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_voltar_pressed() -> void:
	menu_anim.play("menu_close")


func _on_sair_pressed() -> void:
	Glob.is_dialog_active = false
	get_tree().change_scene_to_file("res://predicts/title_screen.tscn")


func _on_salvar_pressed() -> void:
	Glob.is_dialog_active = false
	emit_signal("salvar_game")
	SaveManager.salvar_jogo()
	Glob.cut_scene_init = false
	get_tree().change_scene_to_file("res://predicts/title_screen.tscn")
