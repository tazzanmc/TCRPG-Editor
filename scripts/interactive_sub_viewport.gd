extends Control

const main_scene: String = "res://scenes/main.tscn"

@export var card_json : String = "res://assets/default_card.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	self_modulate = Color(0.99, 0.95, 0.693, 1.0)


func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):	
		self_modulate = Color(0.73, 1.0, 0.775, 1.0)
		%PopupMenu.popup_centered_ratio()
		%PopupMenu.position = DisplayServer.mouse_get_position()


func _on_popup_menu_id_pressed(id: int) -> void:
	# Close popup
	if id == 0 or id == 2:
		return
		
	# Edit button
	if id == 1:
		Global.saved_json = card_json
		print("Global json: " + str(Global.saved_json))
		get_tree().change_scene_to_file(main_scene)
