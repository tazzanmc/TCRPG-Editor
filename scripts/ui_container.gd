extends BoxContainer

var offset: Vector2
var is_dragging: bool

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
