extends CanvasLayer

static var instance = null

@export_group("Open / Close")
@export var start_closed: bool = true
@export var toggle_key: Key = KEY_ESCAPE
@export var open_button: Button

@export_group("Player")
@export var player: Node

@export_group("Visual")
@export var panel_width: float = 270.0
@export var panel_color: Color = Color(0.12, 0.11, 0.16, 0.96)
@export var sidebar_color: Color = Color(0.08, 0.075, 0.11, 1.0)
@export var accent_color: Color = Color(0.48, 0.28, 1.0, 1.0)
@export var animation_time: float = 0.22

@export_group("Controls")
@export var action_names: Array[String] = [
	"p0_button_0",
	"p0_button_1",
	"p0_button_2",
	"p0_button_3"
]

@export var action_labels: Array[String] = [
	"Track 1",
	"Track 2",
	"Track 3",
	"Track 4"
]

@export var default_keys: Array[Key] = [
	KEY_A,
	KEY_S,
	KEY_D,
	KEY_W,
	KEY_SHIFT,
	KEY_SPACE
]

@export_group("Audio")
@export var master_bus_name: String = "Master"
@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"

@export_range(0.0, 100.0)
var default_master_volume: float = 100.0

@export_range(0.0, 100.0)
var default_music_volume: float = 80.0

@export_range(0.0, 100.0)
var default_sfx_volume: float = 80.0


const SAVE_PATH: String = "user://settings.cfg"


var root_panel: Panel
var sidebar: VBoxContainer
var content: VBoxContainer
var scroll_container: ScrollContainer

var master_slider: HSlider
var music_slider: HSlider
var sfx_slider: HSlider

var option_button: OptionButton

var waiting_action: String = ""
var waiting_button: Button = null

var key_buttons: Dictionary = {}

var opened: bool = false
var tween: Tween = null

var debug_enabled: bool = false


func _ready() -> void:
	instance = self
	layer = 999

	create_default_input_actions()
	build_ui()
	load_settings()
	apply_audio_settings()

	if open_button != null:
		open_button.pressed.connect(open_settings)

	if start_closed:
		close_settings_instant()
	else:
		open_settings_instant()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey

		if key_event.pressed and !key_event.echo:

			if waiting_action != "":
				remap_action(waiting_action, key_event.keycode)
				waiting_action = ""
				waiting_button = null
				get_viewport().set_input_as_handled()
				return

			if key_event.keycode == toggle_key:
				toggle_settings()
				get_viewport().set_input_as_handled()


# ============================================================
# UI
# ============================================================

func build_ui() -> void:
	root_panel = Panel.new()
	add_child(root_panel)

	root_panel.anchor_left = 0.0
	root_panel.anchor_top = 0.0
	root_panel.anchor_right = 0.0
	root_panel.anchor_bottom = 1.0

	root_panel.offset_left = 0.0
	root_panel.offset_top = 0.0
	root_panel.offset_right = panel_width
	root_panel.offset_bottom = 0.0

	var style: StyleBoxFlat = StyleBoxFlat.new()

	style.bg_color = panel_color
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_right = 4

	root_panel.add_theme_stylebox_override("panel", style)

	var margin: MarginContainer = MarginContainer.new()

	margin.anchor_right = 1.0
	margin.anchor_bottom = 1.0

	margin.add_theme_constant_override("margin_left", 4)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 4)
	margin.add_theme_constant_override("margin_bottom", 4)

	root_panel.add_child(margin)

	var main: HBoxContainer = HBoxContainer.new()

	main.add_theme_constant_override("separation", 6)

	margin.add_child(main)

	sidebar = VBoxContainer.new()

	sidebar.custom_minimum_size.x = 80.0
	sidebar.add_theme_constant_override("separation", 3)

	main.add_child(sidebar)

	scroll_container = ScrollContainer.new()

	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	main.add_child(scroll_container)

	content = VBoxContainer.new()

	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	content.add_theme_constant_override("separation", 4)

	scroll_container.add_child(content)

	build_sidebar()
	show_general_page()


func build_sidebar() -> void:
	clear_container(sidebar)

	var title: Label = Label.new()

	title.text = "Settings"
	title.add_theme_font_size_override("font_size", 11)
	title.custom_minimum_size.y = 20
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	sidebar.add_child(title)

	create_sidebar_button("General", show_general_page)
	create_sidebar_button("Controls", show_controls_page)
	create_sidebar_button("Audio", show_audio_page)

	var spacer: Control = Control.new()

	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL

	sidebar.add_child(spacer)

	var close_btn: Button = Button.new()

	close_btn.text = "Close"
	close_btn.custom_minimum_size.y = 20
	close_btn.add_theme_font_size_override("font_size", 10)

	close_btn.pressed.connect(close_settings)

	sidebar.add_child(close_btn)


func create_sidebar_button(text: String, callback: Callable) -> void:
	var btn: Button = Button.new()

	btn.text = text
	btn.custom_minimum_size.y = 20
	btn.add_theme_font_size_override("font_size", 10)

	btn.pressed.connect(callback)

	sidebar.add_child(btn)


# ============================================================
# GENERAL
# ============================================================

func show_general_page() -> void:
	clear_container(content)

	content.add_child(create_title("General"))
	content.add_child(create_subtitle("Debug"))
	content.add_child(create_separator())

	var row: HBoxContainer = HBoxContainer.new()

	content.add_child(row)

	var label: Label = Label.new()

	label.text = "Show Debug"
	label.add_theme_font_size_override("font_size", 10)
	label.custom_minimum_size.x = 70

	row.add_child(label)

	option_button = OptionButton.new()

	option_button.custom_minimum_size.x = 90
	option_button.custom_minimum_size.y = 18

	option_button.add_theme_font_size_override("font_size", 9)

	# Opções do Debug
	option_button.add_item("Disabled", 0)
	option_button.add_item("Enabled", 1)

	# Seleciona o estado salvo
	option_button.select(1 if debug_enabled else 0)

	option_button.item_selected.connect(_on_debug_selected)

	row.add_child(option_button)

	var apply_btn: Button = Button.new()

	apply_btn.text = "Apply Changes"
	apply_btn.custom_minimum_size.y = 20

	apply_btn.add_theme_font_size_override("font_size", 10)

	apply_btn.pressed.connect(save_settings)

	content.add_child(apply_btn)


func _on_debug_selected(index: int) -> void:
	debug_enabled = index == 1

	apply_debug_display()

	save_settings()


func apply_debug_display() -> void:
	
	if player == null:
		push_warning("Settings: Player não foi definido no Inspector.")
		return

	var debug_display = player.get_node_or_null("DebugDisplay")

	if debug_display == null:
		push_warning("Settings: não foi encontrado o nó 'DebugDisplay' dentro do Player.")
		return

	debug_display.visible = debug_enabled


# ============================================================
# CONTROLS
# ============================================================

func show_controls_page() -> void:
	clear_container(content)
	key_buttons.clear()

	content.add_child(create_title("Controls"))
	content.add_child(create_subtitle("Remap key bindings"))

	var default_btn: Button = Button.new()

	default_btn.text = "Reset Default"
	default_btn.custom_minimum_size.y = 18
	default_btn.add_theme_font_size_override("font_size", 9)

	default_btn.pressed.connect(reset_controls_to_default)

	content.add_child(default_btn)

	content.add_child(create_separator())

	for i in action_names.size():

		var action: String = action_names[i]

		var label_text: String = (
			action_labels[i]
			if i < action_labels.size()
			else action
		)

		var row: HBoxContainer = HBoxContainer.new()

		content.add_child(row)

		var label: Label = Label.new()

		label.text = label_text
		label.add_theme_font_size_override("font_size", 9)
		label.custom_minimum_size.x = 80

		row.add_child(label)

		var button: Button = Button.new()

		button.text = get_action_key_text(action)

		button.custom_minimum_size.x = 75
		button.custom_minimum_size.y = 18

		button.add_theme_font_size_override("font_size", 9)

		button.pressed.connect(
			func():
				start_remap(action, button)
		)

		row.add_child(button)

		key_buttons[action] = button

	var apply_btn: Button = Button.new()

	apply_btn.text = "Apply"
	apply_btn.custom_minimum_size.y = 20

	apply_btn.add_theme_font_size_override("font_size", 10)

	apply_btn.pressed.connect(save_settings)

	content.add_child(apply_btn)


# ============================================================
# AUDIO
# ============================================================

func show_audio_page() -> void:
	clear_container(content)

	content.add_child(create_title("Audio"))
	content.add_child(create_subtitle("Adjust volumes"))

	var default_btn: Button = Button.new()

	default_btn.text = "Reset Default"
	default_btn.custom_minimum_size.y = 18

	default_btn.add_theme_font_size_override("font_size", 9)

	default_btn.pressed.connect(reset_audio_to_default)

	content.add_child(default_btn)

	content.add_child(create_separator())

	master_slider = create_volume_slider(
		"Master",
		default_master_volume
	)

	music_slider = create_volume_slider(
		"Music",
		default_music_volume
	)

	sfx_slider = create_volume_slider(
		"SFX",
		default_sfx_volume
	)

	content.add_child(master_slider.get_parent())
	content.add_child(music_slider.get_parent())
	content.add_child(sfx_slider.get_parent())

	load_settings_to_sliders()

	var apply_btn: Button = Button.new()

	apply_btn.text = "Apply"
	apply_btn.custom_minimum_size.y = 20

	apply_btn.add_theme_font_size_override("font_size", 10)

	apply_btn.pressed.connect(apply_and_save_audio)

	content.add_child(apply_btn)


func create_volume_slider(
	label_text: String,
	default_value: float
) -> HSlider:

	var box: VBoxContainer = VBoxContainer.new()

	box.add_theme_constant_override("separation", 1)

	var label: Label = Label.new()

	label.text = label_text
	label.add_theme_font_size_override("font_size", 9)

	box.add_child(label)

	var slider: HSlider = HSlider.new()

	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.value = default_value

	slider.custom_minimum_size.y = 14

	box.add_child(slider)

	return slider


func apply_and_save_audio() -> void:
	apply_bus_volume(
		master_bus_name,
		master_slider.value
	)

	apply_bus_volume(
		music_bus_name,
		music_slider.value
	)

	apply_bus_volume(
		sfx_bus_name,
		sfx_slider.value
	)

	save_settings()


func apply_audio_settings() -> void:
	var config: ConfigFile = ConfigFile.new()

	var err: Error = config.load(SAVE_PATH)

	var master_value: float = default_master_volume
	var music_value: float = default_music_volume
	var sfx_value: float = default_sfx_volume

	if err == OK:

		master_value = float(
			config.get_value(
				"audio",
				"master",
				default_master_volume
			)
		)

		music_value = float(
			config.get_value(
				"audio",
				"music",
				default_music_volume
			)
		)

		sfx_value = float(
			config.get_value(
				"audio",
				"sfx",
				default_sfx_volume
			)
		)

	apply_bus_volume(
		master_bus_name,
		master_value
	)

	apply_bus_volume(
		music_bus_name,
		music_value
	)

	apply_bus_volume(
		sfx_bus_name,
		sfx_value
	)


func apply_bus_volume(
	bus_name: String,
	value: float
) -> void:

	var bus_index: int = AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		return

	var linear: float = clampf(
		value / 100.0,
		0.0,
		1.0
	)

	if linear <= 0.0:

		AudioServer.set_bus_mute(
			bus_index,
			true
		)

		AudioServer.set_bus_volume_db(
			bus_index,
			-80.0
		)

	else:

		AudioServer.set_bus_mute(
			bus_index,
			false
		)

		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(linear)
		)


func load_settings_to_sliders() -> void:
	var config: ConfigFile = ConfigFile.new()

	if config.load(SAVE_PATH) != OK:
		return

	if master_slider:
		master_slider.value = float(
			config.get_value(
				"audio",
				"master",
				default_master_volume
			)
		)

	if music_slider:
		music_slider.value = float(
			config.get_value(
				"audio",
				"music",
				default_music_volume
			)
		)

	if sfx_slider:
		sfx_slider.value = float(
			config.get_value(
				"audio",
				"sfx",
				default_sfx_volume
			)
		)


func reset_audio_to_default() -> void:

	if master_slider:
		master_slider.value = default_master_volume

	if music_slider:
		music_slider.value = default_music_volume

	if sfx_slider:
		sfx_slider.value = default_sfx_volume

	apply_and_save_audio()


# ============================================================
# INPUT
# ============================================================

func create_default_input_actions() -> void:

	for i in action_names.size():

		var action: String = action_names[i]

		if !InputMap.has_action(action):
			InputMap.add_action(action)

		if (
			InputMap.action_get_events(action).is_empty()
			and i < default_keys.size()
		):

			var ev: InputEventKey = InputEventKey.new()

			ev.keycode = default_keys[i]

			InputMap.action_add_event(
				action,
				ev
			)


func start_remap(
	action: String,
	button: Button
) -> void:

	waiting_action = action
	waiting_button = button

	button.text = "Press key..."


func remap_action(
	action: String,
	keycode: Key
) -> void:

	InputMap.action_erase_events(action)

	var ev: InputEventKey = InputEventKey.new()

	ev.keycode = keycode

	InputMap.action_add_event(
		action,
		ev
	)

	if (
		key_buttons.has(action)
		and key_buttons[action] != null
	):

		key_buttons[action].text = OS.get_keycode_string(
			keycode
		)

	save_settings()


func reset_controls_to_default() -> void:

	for i in action_names.size():

		if i < default_keys.size():

			remap_action(
				action_names[i],
				default_keys[i]
			)

	save_settings()


func get_action_key_text(action: String) -> String:

	for event in InputMap.action_get_events(action):

		if event is InputEventKey:

			return OS.get_keycode_string(
				(event as InputEventKey).keycode
			)

	return "None"


# ============================================================
# SAVE / LOAD
# ============================================================

func save_settings() -> void:

	var config: ConfigFile = ConfigFile.new()

	config.load(SAVE_PATH)

	# Debug
	config.set_value(
		"general",
		"debug",
		debug_enabled
	)

	# Audio
	if master_slider:
		config.set_value(
			"audio",
			"master",
			master_slider.value
		)

	if music_slider:
		config.set_value(
			"audio",
			"music",
			music_slider.value
		)

	if sfx_slider:
		config.set_value(
			"audio",
			"sfx",
			sfx_slider.value
		)

	# Controls
	for action_variant in action_names:

		var action: String = str(action_variant)

		for event in InputMap.action_get_events(action):

			if event is InputEventKey:

				config.set_value(
					"keys",
					action,
					int(
						(event as InputEventKey).keycode
					)
				)

				break

	config.save(SAVE_PATH)


func load_settings() -> void:

	var config: ConfigFile = ConfigFile.new()

	var err: Error = config.load(SAVE_PATH)

	# -------------------------
	# Debug
	# -------------------------

	if err == OK:

		debug_enabled = bool(
			config.get_value(
				"general",
				"debug",
				false
			)
		)

	else:

		debug_enabled = false

	apply_debug_display()

	# -------------------------
	# Idioma
	# -------------------------

	var loc_mgr = get_node_or_null(
		"/root/LocalizationManager"
	)

	if (
		loc_mgr
		and loc_mgr.has_method("change_language")
	):

		var saved_lang: String = String(
			config.get_value(
				"general",
				"language",
				"en"
			)
		)

		loc_mgr.change_language(saved_lang)

	# -------------------------
	# Controls
	# -------------------------

	if err != OK:
		return

	for action_variant in action_names:

		var action: String = str(action_variant)

		if config.has_section_key(
			"keys",
			action
		):

			var keycode: Key = int(
				config.get_value(
					"keys",
					action
				)
			)

			InputMap.action_erase_events(
				action
			)

			var ev: InputEventKey = InputEventKey.new()

			ev.keycode = keycode

			InputMap.action_add_event(
				action,
				ev
			)


# ============================================================
# HELPERS
# ============================================================

func create_title(text: String) -> Label:

	var label: Label = Label.new()

	label.text = text
	label.add_theme_font_size_override(
		"font_size",
		13
	)

	return label


func create_subtitle(text: String) -> Label:

	var label: Label = Label.new()

	label.text = text
	label.add_theme_font_size_override(
		"font_size",
		9
	)

	return label


func create_separator() -> HSeparator:

	var sep: HSeparator = HSeparator.new()

	sep.custom_minimum_size.y = 4

	return sep


func clear_container(container: Container) -> void:

	for child in container.get_children():

		child.queue_free()


# ============================================================
# OPEN / CLOSE
# ============================================================

func open_settings() -> void:

	if opened:
		return

	opened = true

	root_panel.visible = true

	if tween:
		tween.kill()

	root_panel.position.x = -panel_width

	tween = create_tween()

	tween.set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_OUT
	)

	tween.tween_property(
		root_panel,
		"position:x",
		0.0,
		animation_time
	)


func close_settings() -> void:

	if !opened:
		return

	opened = false

	if tween:
		tween.kill()

	tween = create_tween()

	tween.set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_IN
	)

	tween.tween_property(
		root_panel,
		"position:x",
		-panel_width,
		animation_time
	)

	await tween.finished

	root_panel.visible = false


func open_settings_instant() -> void:

	opened = true

	root_panel.visible = true

	root_panel.position.x = 0.0


func close_settings_instant() -> void:

	opened = false

	root_panel.visible = false

	root_panel.position.x = -panel_width


func toggle_settings() -> void:

	if opened:
		close_settings()
	else:
		open_settings()
