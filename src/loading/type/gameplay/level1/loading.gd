extends Control

# ==========================================
# CONFIGURAÇÃO
# ==========================================

@export_category("Scene")

@export var scene_to_load: PackedScene


@export_category("UI")

@export var progress_bar: ProgressBar
@export var label: Label
@export var anim: AnimationPlayer
@export var sprite: AnimatedSprite2D


@export_category("Loading")

@export var dot_speed: float = 0.5


# ==========================================
# VARIÁVEIS
# ==========================================

var scene_path: String = ""

var loading_status: ResourceLoader.ThreadLoadStatus
var progress: Array = []

var loading_text: String = "Loading"

var dots: int = 0
var dot_timer: float = 0.0

var started_loading: bool = false
var finished_loading: bool = false


# ==========================================
# READY
# ==========================================

func _ready() -> void:

	# --------------------------------------
	# VERIFICA UI
	# --------------------------------------

	if progress_bar == null:
		push_error("Loading: ProgressBar não definido.")

	if label == null:
		push_error("Loading: Label não definido.")

	if anim == null:
		push_error("Loading: AnimationPlayer não definido.")

	if sprite == null:
		push_error("Loading: AnimatedSprite2D não definido.")


	# --------------------------------------
	# CONFIGURA BARRA
	# --------------------------------------

	if progress_bar:
		progress_bar.min_value = 0.0
		progress_bar.max_value = 100.0
		progress_bar.value = 0.0


	# --------------------------------------
	# TEXTO
	# --------------------------------------

	if label:
		label.text = loading_text


	# --------------------------------------
	# ANIMAÇÃO
	# --------------------------------------

	if sprite:
		sprite.play("loading_playar")

#if anim:
		#anim.play("loading_in")


	# --------------------------------------
	# VERIFICA CENA
	# --------------------------------------

	if scene_to_load == null:
		if label:
			label.text = "No scene"

		push_error(
			"Loading: nenhuma PackedScene foi definida."
		)

		return


	# --------------------------------------
	# PEGA O CAMINHO REAL DA CENA
	# --------------------------------------

	scene_path = scene_to_load.resource_path

	if scene_path.is_empty():
		if label:
			label.text = "Invalid scene"

		push_error(
			"Loading: a cena não possui resource_path."
		)

		return


	# --------------------------------------
	# INICIA CARREGAMENTO
	# --------------------------------------

	await get_tree().process_frame

	var error: Error = ResourceLoader.load_threaded_request(
		scene_path
	)

	if error != OK:
		if label:
			label.text = "Loading Error"

		push_error(
			"Loading: erro ao iniciar carregamento: "
			+ str(error)
		)

		return


	started_loading = true


# ==========================================
# PROCESS
# ==========================================

func _process(delta: float) -> void:

	if not started_loading:
		return


	# ======================================
	# ANIMAÇÃO DO TEXTO
	# ======================================

	if not finished_loading:

		dot_timer += delta

		if dot_timer >= dot_speed:

			dot_timer = 0.0

			dots += 1

			if dots > 3:
				dots = 0

			if label:
				label.text = (
					loading_text
					+ ".".repeat(dots)
				)


	# ======================================
	# VERIFICA STATUS
	# ======================================

	loading_status = ResourceLoader.load_threaded_get_status(
		scene_path,
		progress
	)


	# ======================================
	# PROGRESSO
	# ======================================

	if progress.size() > 0:

		var percentage: float = (
			float(progress[0]) * 100.0
		)

		if progress_bar:
			progress_bar.value = percentage


	# ======================================
	# ESTADOS
	# ======================================

	match loading_status:

		ResourceLoader.THREAD_LOAD_IN_PROGRESS:

			pass


		ResourceLoader.THREAD_LOAD_LOADED:

			if finished_loading:
				return

			finished_loading = true


			if progress_bar:
				progress_bar.value = 100.0


			var packed_scene: PackedScene = (
				ResourceLoader.load_threaded_get(
					scene_path
				) as PackedScene
			)


			if packed_scene != null:

				get_tree().change_scene_to_packed(
					packed_scene
				)

			else:

				if label:
					label.text = "Loading Error"

				push_error(
					"Loading: não foi possível obter a PackedScene."
				)


		ResourceLoader.THREAD_LOAD_FAILED:

			started_loading = false

			if label:
				label.text = "Loading Failed"

			push_error(
				"Loading: falha ao carregar: "
				+ scene_path
			)


		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:

			started_loading = false

			if label:
				label.text = "Invalid Resource"

			push_error(
				"Loading: recurso inválido: "
				+ scene_path
			)
