extends Control

@export var pause: Control
@export var button: Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_button_pressed():
	pause.toggle_pause()
