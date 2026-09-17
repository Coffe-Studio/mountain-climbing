extends Node2D
class_name LevelTuto

@export var fala1: Area2D

const _DIALOG_SCREEN: PackedScene = preload("res://src/ui/dialog/dialog_screen.tscn")

var _dialog_data: Dictionary = {
	0: {
		"dialog": "teste de dialogos fodas, isso está demorando pra prr ;-;",
		"title": "Teste"
	},
	1: {
		"dialog": "Mas acho que vai dar errado...",
		"title": "Teste"
	},
	2: {
		"dialog": "Será?",
		"title": "Teste"
	}
}


@export_category("Objects")
@export var _hud: CanvasLayer


var _dialog_open: bool = false


func _process(_delta: float) -> void:
	pass


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



func _on_dialog_1_body_entered(_body: Node2D) -> void:
	if not _body == CharacterBody2D:
		_open_dialog()
		if _dialog_open:
			return
	else:
		print("sa porra não tá reconecendo")
