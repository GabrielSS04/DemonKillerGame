extends Node

# SaveManager.gd
var save_path := "user://savegame.save"  # Você também pode usar .json se quiser ler manualmente
var player : CharacterBody2D
var lastScenePath:String = ""

func _ready():
	lastScenePath = get_tree().current_scene.scene_file_path

func set_player(p: CharacterBody2D):
	player = p

func save_game(data: Dictionary) -> void:
	lastScenePath = get_tree().current_scene.scene_file_path
	data["scenePath"] = lastScenePath 
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_game() -> Dictionary:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		return data
	else:
		return {}  # Retorna dicionário vazio se não existir


func salvar_jogo():
	var dados := {
		"player_position": player.global_position,
		"time": Glob.time,
	}
	save_game(dados)
	print("Jogo salvo!")
	print(dados)

func carregar_jogo():
	var dados = load_game()
	print(dados)
	
	var scene_Path = dados["scenePath"]
	var nova_scene = load(scene_Path).instantiate()
	get_tree().root.add_child(nova_scene)
	get_tree().current_scene = nova_scene
	await get_tree().process_frame
	
	var jogador = nova_scene.get_node("Player")
	
	if dados.has("player_position"):
		jogador.global_position = dados["player_position"]
	if dados.has("time"):
		Glob.time = dados["time"]
	print("Jogo carregado!")
