extends Control

@export var card_scene: PackedScene

@onready var card_inst : Card = card_scene.instantiate()

@onready var art_file : ImageTexture = ImageTexture.create_from_image(Image.load_from_file("res://assets/textures/2bcw4gdw4r8c1.jpeg"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_text() -> void:
	%XOffsetLabel.text = str(int(%XOffsetSlider.value))
	%YOffsetLabel.text = str(int(%YOffsetSlider.value))
	%ScaleLabel.text = str(%ScaleSlider.value)


func update_card() -> void:
	%CardViewport.remove_child(card_inst)
	
	card_inst.change_name(%NameField.text)
	card_inst.change_traits(%TraitsField.text)
	card_inst.change_type(%TypeOption.text)
	card_inst.change_power(str(int(%PowerNumber.value)))
	card_inst.change_health(str(int(%HealthNumber.value)))
	card_inst.change_abilities(%AbilitiesField.text)
	card_inst.change_art(art_file, Vector2(int(%XOffsetSlider.value),int(%YOffsetSlider.value)), %ScaleSlider.value)
	
	if %XCheckBox.button_pressed:
		card_inst.change_tribute("X")
	else:
		card_inst.change_tribute(str(int(%CostNumber.value)))
	
	var guilds : Array = []
	for child in %GuildContainer.get_children():
		if child.button_pressed == true:
			guilds.append(true)
		else:
			guilds.append(false)
	
	card_inst.change_guids(guilds)
	
	%CardViewport.add_child(card_inst)


func _on_create_button_pressed() -> void:
	update_card()


func _on_save_button_pressed() -> void:
	await get_tree().create_timer(1).timeout
	%Screenshotter.TAKE_SCREENSHOT(%NameField.text)


func _on_art_button_pressed() -> void:
	%ArtFileDialog.popup_centered_clamped()


func _on_art_file_dialog_file_selected(path: String) -> void:
	art_file = ImageTexture.create_from_image(Image.load_from_file(path))


func _on_timer_timeout() -> void:
	update_text()
	update_card()
