extends Control

class_name DialogScreen

var step: float = 0.05
var id = 0

var data : Dictionary = {}

signal dialog_ended

@export_category("object")
@export var face_image: TextureRect = null
@export var nome: Label = null
@export var dialog: RichTextLabel = null


func _ready() -> void:
	start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("chat") and dialog.visible_ratio < 1:
		step = 0.01
		return
	
	step = 0.05
	if Input.is_action_just_pressed("chat"):
		id += 1
		if id == data.size():
			Glob.is_dialog_active = false
			emit_signal("dialog_ended")
			queue_free()
			return
		start()
		


func start() -> void:
	Glob.is_dialog_active = true
	nome.text = data[id]["title"]
	face_image.texture = load(data[id]["image"])
	dialog.text = data[id]["dialog"]
	
	dialog.visible_characters = 0
	
	while dialog.visible_ratio < 1:
		await get_tree().create_timer(step).timeout
		dialog.visible_characters += 1
	
	
