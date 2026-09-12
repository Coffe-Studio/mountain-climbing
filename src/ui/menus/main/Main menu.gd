extends Node2D

@export var animation : AnimationPlayer

# Start
func _ready():
	animation.play("Camera_IN")

func _on_play_pressed():
	animation.play("Play_out")
	await animation.animation_finished
	get_tree().change_scene_to_file("res://src/loading/type/gameplay/level1/loading_tutorial.tscn")

func _on_quit_pressed():
	$Settings.visible = false
	animation.play("Quit_out")
	await animation.animation_finished
	get_tree().quit(0)
