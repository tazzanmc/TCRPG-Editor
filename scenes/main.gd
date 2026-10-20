extends Control

@export var zoom: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 5.0

var cam_control: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.global_signal.connect(swapper)
	swap_to_editor()


func _unhandled_input(event: InputEvent):
	if cam_control:
		if event.is_action_pressed("ZoomIn"):
			if %Camera2D.zoom <= Vector2(max_zoom, max_zoom):
				%Camera2D.zoom += Vector2(zoom, zoom)
		if event.is_action_pressed("ZoomOut"):
			if %Camera2D.zoom > Vector2(min_zoom, min_zoom):
				%Camera2D.zoom -= Vector2(zoom, zoom)


func swapper(to: String) -> void:
	if to == "editor":
		swap_to_editor(true)
	elif to == "viewer":
		swap_to_viewer(true)


func swap_to_viewer(from_signal: bool = false) -> void:
	cam_control = true
	%CardEditor.hide_scene(from_signal)
	%CardViewer.unhide_scene(from_signal)


func swap_to_editor(from_signal: bool = false) -> void:
	cam_control = false
	%CardViewer.hide_scene(from_signal)
	%CardEditor.unhide_scene(from_signal)
