class_name Run extends Ground

@onready var running_dust: CPUParticles2D = $"../../../Effects/RunningDust"
@onready var footstep_sound: AudioStreamPlayer2D = $"../../../Footstep"

@export var footstep_frames: Array[int] = [1, 3, 5, 7]


func _enter():
	if animated_sprite:
		animated_sprite.play("run")

		if not animated_sprite.frame_changed.is_connected(_on_run_frame_changed):
			animated_sprite.frame_changed.connect(_on_run_frame_changed)

	if running_dust:
		running_dust.emitting = true

	godot_essentials_platformer_movement.reset_jump_queue()

	if previous_states.back() is Air:
		godot_essentials_platformer_movement.velocity.y = 0


func _exit():
	if animated_sprite and animated_sprite.frame_changed.is_connected(_on_run_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_run_frame_changed)

	if running_dust:
		running_dust.emitting = false


func _on_run_frame_changed() -> void:
	if animated_sprite.frame in footstep_frames:
		if footstep_sound:
			footstep_sound.play()


func physics_update(delta):
	super.physics_update(delta)

	if horizontal_direction.is_zero_approx():
		if godot_essentials_platformer_movement.velocity.x == 0:
			state_finished.emit("Idle", {})
			return
		else:
			godot_essentials_platformer_movement.decelerate_horizontally(delta)
	else:
		godot_essentials_platformer_movement.accelerate_horizontally(horizontal_direction, delta)
		emit_dust_particles(horizontal_direction)

	godot_essentials_platformer_movement.move()

	if Input.is_action_just_pressed("jump"):
		state_finished.emit("Jump", {})
		return

	if Input.is_action_just_pressed("dash") and godot_essentials_platformer_movement.can_dash(input_direction):
		state_finished.emit("Dash", {})
		return

	if godot_essentials_platformer_movement.is_falling():
		state_finished.emit("Fall", {})


func emit_dust_particles(horizontal_direction: Vector2):
	match(horizontal_direction):
		Vector2.RIGHT:
			running_dust.gravity = Vector2(-running_dust.gravity.x, running_dust.gravity.y)

		Vector2.LEFT:
			running_dust.gravity = Vector2(abs(running_dust.gravity.x), running_dust.gravity.y)

	running_dust.direction = horizontal_direction
