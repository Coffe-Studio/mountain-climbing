extends Node2D
class_name LevelTuto

const _DIALOG_SCREEN: PackedScene = preload("res://src/ui/dialog/dialog_screen.tscn")


var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "teste de dialogos fodas, isso está demorando pra prr ;-;",
		"title": "Teste"
	},
	1: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Mas acho que vai dar errado...",
		"title": "Teste"
	},
	2: {
		"faceset": "res://assets/character_animations/death_frame.png",
		"dialog": "Será?",
		"title": "Teste"
	}
}


@export_category("Objects")
@export var _hud: CanvasLayer


var _dialog_open: bool = false


func _process(_delta: float) -> void:

	# Dispara somente uma vez quando o botão é pressionado
	if Input.is_action_just_pressed("pular_dialogo"):

		# Não cria outro diálogo se já existe um aberto
		if _dialog_open:
			return

		_open_dialog()


func _open_dialog() -> void:

	if _hud == null:
		push_error("HUD não foi definido no Inspector.")
		return

	var new_dialog: DIalogScreen = _DIALOG_SCREEN.instantiate()

	new_dialog.data = _dialog_data

	# Avisamos quando o diálogo for destruído
	new_dialog.tree_exited.connect(_on_dialog_closed)

	_hud.add_child(new_dialog)

	_dialog_open = true


func _on_dialog_closed() -> void:
	_dialog_open = false
