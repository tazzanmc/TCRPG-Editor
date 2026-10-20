extends Control

@export var zoom: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 5.0

var cam_control: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swap_to_editor()


func _unhandled_input(event: InputEvent):
	if cam_control:
		if event.is_action_pressed("ZoomIn"):
			if %Camera2D.zoom <= Vector2(max_zoom, max_zoom):
				%Camera2D.zoom += Vector2(zoom, zoom)
		if event.is_action_pressed("ZoomOut"):
			if %Camera2D.zoom > Vector2(min_zoom, min_zoom):
				%Camera2D.zoom -= Vector2(zoom, zoom)


func swap_to_viewer() -> void:
	cam_control = true
	%CardViewer.unhide_scene()
	%CardEditor.hide_scene()


func swap_to_editor() -> void:
	cam_control = false
	%CardViewer.hide_scene()
	%CardEditor.unhide_scene()
