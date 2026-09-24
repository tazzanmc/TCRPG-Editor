extends BoxContainer

var offset: Vector2
var is_dragging: bool

@export var zoom: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Set initial rotation, position, offset, and global is dragging on pickup
	if Input.is_action_just_pressed("Pan"):
		offset = get_global_mouse_position() - global_position
		is_dragging = true
	# Move self with mouse drag
	if Input.is_action_pressed("Pan"):
		if is_dragging:
			global_position = get_global_mouse_position() - offset
	# Release Logic
	elif Input.is_action_just_released("Pan"):
		is_dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ZoomIn"):
		if %Camera2D.zoom <= Vector2(max_zoom, max_zoom):
			%Camera2D.zoom += Vector2(zoom, zoom)
	if event.is_action_pressed("ZoomOut"):
		if %Camera2D.zoom > Vector2(min_zoom, min_zoom):
			%Camera2D.zoom -= Vector2(zoom, zoom)
