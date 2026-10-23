extends Control

@export var zoom: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 5.0

var cam_control: bool = false
var drag_start_mouse: Vector2
var drag_start_cam: Vector2
var is_dragging: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.global_signal.connect(signal_reader)
	swap_to_editor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if cam_control:
		# Set initial rotation, position, offset, and global is dragging on pickup
		if Input.is_action_just_pressed("Pan"):
			drag_start_mouse = get_viewport().get_mouse_position()
			drag_start_cam = %Camera2D.position
			is_dragging = true
		# Move self with mouse drag
		if Input.is_action_pressed("Pan"):
			if is_dragging:
				var mouse_delta : Vector2 = get_viewport().get_mouse_position() - drag_start_mouse
				# Screen pixels cover fewer world units when zoomed in, so divide by zoom
				%Camera2D.position = drag_start_cam - mouse_delta / %Camera2D.zoom
		# Release Logic
		elif Input.is_action_just_released("Pan"):
			is_dragging = false


func _unhandled_input(event: InputEvent):
	if cam_control:
		if event.is_action_pressed("ZoomIn"):
			if %Camera2D.zoom <= Vector2(max_zoom, max_zoom):
				%Camera2D.zoom += Vector2(zoom, zoom)
		if event.is_action_pressed("ZoomOut"):
			if %Camera2D.zoom > Vector2(min_zoom, min_zoom):
				%Camera2D.zoom -= Vector2(zoom, zoom)


func signal_reader(to: String) -> void:
	if to == "editor":
		swap_to_editor(true)
	elif to == "viewer":
		swap_to_viewer(true)
	elif to == "cam_on":
		cam_control = true
	elif to == "cam_off":
		cam_control = false


func swap_to_viewer(from_signal: bool = false) -> void:
	cam_control = true
	%CardEditor.hide_scene(from_signal)
	%CardViewer.unhide_scene(from_signal)


func swap_to_editor(from_signal: bool = false) -> void:
	cam_control = false
	%CardViewer.hide_scene(from_signal)
	%CardEditor.unhide_scene(from_signal)
