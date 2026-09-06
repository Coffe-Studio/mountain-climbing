extends Control

# ==========================================
# CONFIGURAÇÃO
# ==========================================

@export_category("Cene")
@export_file("*.tscn") var scene_to_load: String

@export_category("Ui")
@export var progress_bar: ProgressBar
@export var label: Label
@export var anim: AnimationPlayer
@export var sprite: AnimatedSprite2D


# ==========================================
# VARIÁVEIS
# ==========================================

var loading_status := ResourceLoader.THREAD_LOAD_INVALID_RESOURCE
var progress: Array = []

var loading_text := "Loading"

var dots := 0
var dot_timer := 0.0

# Tempo entre cada mudança dos pontos
@export var dot_speed := 0.5


# ==========================================
# INÍCIO
# ==========================================

func _ready():

	sprite.play("loading_playar")
	anim.play("loading_in")
	await anim.animation_finished

	# Verifica se existe uma cena definida
	if scene_to_load.is_empty():
		label.text = "Erro: nenhuma cena definida."
		push_error("Loading: scene_to_load está vazio.")
		return

	# Começa o carregamento em segundo plano
	var error := ResourceLoader.load_threaded_request(scene_to_load)

	if error != OK:
		label.text = "Erro ao iniciar carregamento."
		push_error(
			"Erro ao iniciar carregamento: " + str(error)
		)

		return

	# Inicializa a barra
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 0

	# Texto inicial
	label.text = loading_text


# ==========================================
# PROCESSAMENTO
# ==========================================

func _process(delta):
	# ------------------------------------------
	# ANIMAÇÃO DO TEXTO
	# ------------------------------------------

	dot_timer += delta

	if dot_timer >= dot_speed:
		dot_timer = 0.0

		dots += 1

		if dots > 3:
			dots = 0

		label.text = loading_text + ".".repeat(dots)


	# ------------------------------------------
	# VERIFICA O CARREGAMENTO
	# ------------------------------------------

	loading_status = ResourceLoader.load_threaded_get_status(
		scene_to_load,
		progress
	)


	# ------------------------------------------
	# ATUALIZA A BARRA DE PROGRESSO
	# ------------------------------------------

	if progress.size() > 0:
		var percentage : float = progress[0] * 100.0

		progress_bar.value = percentage


	# ------------------------------------------
	# ESTADO DO CARREGAMENTO
	# ------------------------------------------

	match loading_status:

		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# Ainda carregando
			pass


		ResourceLoader.THREAD_LOAD_LOADED:
			# Terminou de carregar

			var packed_scene := ResourceLoader.load_threaded_get(
				scene_to_load
			)

			if packed_scene:
				get_tree().change_scene_to_packed(
					packed_scene
				)


		ResourceLoader.THREAD_LOAD_FAILED:
			# Falha no carregamento

			label.text = "Falha ao carregar."

			push_error(
				"Falha ao carregar a cena: "
				+ scene_to_load
			)


		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			# Recurso inválido

			label.text = "Recurso inválido."

			push_error(
				"Recurso inválido: "
				+ scene_to_load
			)
