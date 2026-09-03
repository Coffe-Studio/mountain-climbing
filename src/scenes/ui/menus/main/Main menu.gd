extends Node2D

@export var SondInitial : AudioStreamPlayer2D
@export var animation : AnimationPlayer

# Start
func _ready():
	SondInitial.play()
	animation.play("Camera_IN")

func _on_play_pressed():
	animation.play("Play_out")
	await animation.animation_finished
	get_tree().change_scene_to_file("res://src/scenes/levels/Level tutorial/Level Tuto.tscn")

func _on_quit_pressed():
	$Settings.visible = false
	animation.play("Quit_out")
	await animation.animation_finished
	get_tree().quit(0)
