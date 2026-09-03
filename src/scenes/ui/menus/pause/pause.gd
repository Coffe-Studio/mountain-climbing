extends Control

@onready var menu = $"."
@export var anim : AnimationPlayer

var pausado := false


func _ready():
	menu.visible = false
	
	# Permite que este nó continue funcionando. mesmo quando o jogo estiver pausado.
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event):
	if event.is_action_pressed("pause"):
		anim.play("pause_in")
		toggle_pause()


func toggle_pause():
	pausado = !pausado
	get_tree().paused = pausado
	menu.visible = pausado

func _on_quit_pressed() -> void:
	anim.play("pause_out")
	await anim.animation_finished
	get_tree().quit()


func _on_back_pressed() -> void:
	anim.play("pause_out")
	await anim.animation_finished
	toggle_pause()
