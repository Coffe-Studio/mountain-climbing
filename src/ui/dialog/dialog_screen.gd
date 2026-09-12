extends Control
class_name DIalogScreen

# Velocidade normal de digitação
@export_category("Configuração")
@export var normal_speed: float = 0.05

# Velocidade quando o jogador segura o botão
@export var fast_speed: float = 0.01


@export_category("Objects")
@export var _name: Label
@export var _dialog: RichTextLabel
@export var _faceset: TextureRect
@export var _sond: AudioStreamPlayer


# Dados do diálogo
var data: Dictionary = {}

# Fala atual
var _id: int = 0

# Controle da animação
var _is_typing: bool = false
var _skip_typing: bool = false


func _ready() -> void:
	_initialize_dialog()


func _process(_delta: float) -> void:
	if data.is_empty():
		return

	# Segurar o botão do teclado acelera a escrita
	# O mouse também acelera enquanto estiver segurado
	_skip_typing = Input.is_action_pressed("pular_dialogo") \
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)


	# Teclado
	if Input.is_action_just_pressed("pular_dialogo"):
		_handle_dialog_input()


func _input(event: InputEvent) -> void:
	# Clique esquerdo do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_dialog_input()


func _handle_dialog_input() -> void:
	if data.is_empty():
		return

	# Se ainda está digitando, completa a fala
	if _is_typing:
		_finish_typing()
		return

	# Se terminou de escrever, vai para a próxima fala
	_id += 1

	if _id >= data.size():
		queue_free()
		return

	_initialize_dialog()


func _initialize_dialog() -> void:
	# Evita acessar uma fala que não existe
	if _id < 0 or _id >= data.size():
		queue_free()
		return

	# Para qualquer animação anterior
	_is_typing = false

	# Obtém os dados da fala
	var current_dialog: Dictionary = data[_id]

	# Nome
	if _name:
		_name.text = str(current_dialog.get("title", ""))

	# Texto
	if _dialog:
		_dialog.text = str(current_dialog.get("dialog", ""))

	# Retrato
	if _faceset:
		var faceset_path: String = str(current_dialog.get("faceset", ""))

		if faceset_path.is_empty():
			_faceset.texture = null
		else:
			var texture = load(faceset_path)

			if texture:
				_faceset.texture = texture
			else:
				push_warning(
					"Não foi possível carregar o faceset: " + faceset_path
				)

	# Começa a animação
	_dialog.visible_characters = 0

	_type_dialog()


func _type_dialog() -> void:
	if not _dialog:
		return

	_is_typing = true

	while _dialog.visible_characters < _dialog.text.length():

		var current_speed := normal_speed

		# Segurar teclado ou mouse acelera a escrita
		if _skip_typing:
			current_speed = fast_speed

		await get_tree().create_timer(current_speed).timeout

		if not is_inside_tree():
			return

		if not _is_typing:
			return

		_dialog.visible_characters += 1

		_play_text_sound()

	_is_typing = false


func _play_text_sound() -> void:
	if _sond == null:
		return

	if _dialog.visible_characters <= 0:
		return

	var character := _dialog.text[_dialog.visible_characters - 1]

	# Não toca som em espaços
	if character == " ":
		return

	# Pequena variação de pitch para cada letra
	_sond.pitch_scale = randf_range(0.95, 1.05)

	# Toca o som
	_sond.play()


func _finish_typing() -> void:
	if not _dialog:
		return

	# Para a animação atual
	_is_typing = false

	# Mostra todo o texto imediatamente
	_dialog.visible_characters = -1
