extends Node2D

@export var animation : AnimationPlayer

# Start

func _ready():
	animation.play("Camera_IN")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://src/scenes/levels/Level tutorial/Level Tuto.tscn")
