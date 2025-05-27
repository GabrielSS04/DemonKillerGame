extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var anim: AnimationPlayer = $anim
@onready var valor_music_levep: Label = $HBoxContainer2/VBoxContainer/HBoxContainer/valorMusicLevep
@onready var ambient_music: AudioStreamPlayer2D = $ambient_music
@onready var sound_hover_button: AudioStreamPlayer2D = $sound_hover_button
@onready var sound_click_button: AudioStreamPlayer2D = $sound_click_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ambient_music.volume_db = Glob.music_value


func _on_start_btn_pressed() -> void:
	sound_click_button.play()
	ambient_music.stop()
	Glob.cut_scene_init = true
	get_tree().change_scene_to_file("res://stages/stage_01.tscn")
	


func _on_config_btn_pressed() -> void:
	sound_click_button.play()
	anim.play("config_open")


func _on_end_btn_pressed() -> void:
	sound_click_button.play()
	get_tree().quit()


func _on_anim_animation_finished(anim_name: StringName) -> void:
	color_rect.visible = false


func _on_load_btn_pressed() -> void:	
	sound_click_button.play()
	ambient_music.stop()
	Glob.cut_scene_init = false
	SaveManager.carregar_jogo()


func _on_h_slider_value_changed(value: float) -> void:
	Glob.music_value = value
	valor_music_levep.text = str(value+80.0)


func _on_button_pressed() -> void:
	sound_click_button.play()
	anim.play("config_closing")


func _on_start_btn_mouse_entered() -> void:
	sound_hover_button.play()


func _on_load_btn_mouse_entered() -> void:
	sound_hover_button.play()


func _on_config_btn_mouse_entered() -> void:
	sound_hover_button.play()


func _on_end_btn_mouse_entered() -> void:
	sound_hover_button.play()


func _on_button_mouse_entered() -> void:
	sound_hover_button.play()
