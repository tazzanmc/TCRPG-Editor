extends Control

@export var card_json : String = "res://assets/default_card.json"


func _on_mouse_entered() -> void:
	self_modulate = Color(0.99, 0.95, 0.693, 1.0)


func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_gui_input(_event: InputEvent) -> void:
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
		Global.emit_global_signal("editor")
	
	# Flip button
	if id == 3:
		# Get the cards from the child sub viewports
		var children : Array = get_children()
		var viewports : Array
		for i in range(children.size()):
			if children[i] is SubViewport:
				viewports.append(children[i])
		
		var cards : Array
		for i in range(viewports.size()):
			cards.append(viewports[i].get_child(0))
		
		# Only flip if there's more than 1 card in this viewport
		if cards.size() > 1:
			for i in range(cards.size()):
				if cards[i].visible == true:
					cards[i].visible = false
				else:
					cards[i].visible = true
					card_json = cards[i].card_json_path
