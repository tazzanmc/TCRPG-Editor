extends Control

var art_path : String = "res://assets/textures/art_placeholder.png"

@export var card_scene: PackedScene

@onready var card_inst : Card = card_scene.instantiate()
@onready var art_file : ImageTexture = ImageTexture.create_from_image(Image.load_from_file(art_path))
@onready var saved_card: Dictionary = Global.parse_json("res://assets/default_card.json")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(saved_card["Art"])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_text() -> void:
	%XOffsetLabel.text = str(int(%XOffsetSlider.value))
	%YOffsetLabel.text = str(int(%YOffsetSlider.value))
	%ScaleLabel.text = str(%ScaleSlider.value)


func update_card(guilds: Array = []) -> void:
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
	
	if guilds.size() != 5:
		for child in %GuildContainer.get_children():
			if child.button_pressed == true:
				guilds.append(true)
			else:
				guilds.append(false)
	
	
	card_inst.change_guids(guilds)
	
	%CardViewport.add_child(card_inst)


func load_card() -> void:
	print(saved_card["Art"])
	var json_art_path : String = saved_card["Art"]
	art_file = ImageTexture.create_from_image(Image.load_from_file(json_art_path))
	
	%NameField.text = saved_card["Name"]
	%TraitsField.text = saved_card["Traits"]
	%TypeOption.text = saved_card["Type"]
	%PowerNumber.value = saved_card["Power"]
	%HealthNumber.value = saved_card["Health"]
	%AbilitiesField.text = saved_card["Abilities"]
	%XOffsetSlider.value = saved_card["ArtXOffset"]
	%YOffsetSlider.value = saved_card["ArtYOffset"]
	%ScaleSlider.value = saved_card["ArtScale"]
	%XCheckBox.button_pressed = saved_card["X"]
	%CostNumber.value = saved_card["Tribute"]
	
	var saved_guilds : Array = saved_card["Guilds"]
	var i : int = 0
	
	for child in %GuildContainer.get_children():
		child.button_pressed = saved_guilds[i]
		i += 1
	
	update_card(saved_guilds)


func save_card() -> void:
	saved_card["Art"] = art_path
	saved_card["Name"] = %NameField.text
	saved_card["Traits"] = %TraitsField.text
	saved_card["Type"] = %TypeOption.text
	saved_card["Power"] = %PowerNumber.value
	saved_card["Health"] = %HealthNumber.value
	saved_card["Abilities"] = %AbilitiesField.text
	saved_card["ArtXOffset"] = %XOffsetSlider.value
	saved_card["ArtYOffset"] = %YOffsetSlider.value
	saved_card["ArtScale"] = %ScaleSlider.value
	saved_card["X"] = %XCheckBox.button_pressed
	saved_card["Tribute"] = %CostNumber.value
	
	var guilds : Array
	
	for child in %GuildContainer.get_children():
		if child.button_pressed == true:
			guilds.append(true)
		else:
			guilds.append(false)
	
	saved_card["Guilds"] = guilds


func _on_create_button_pressed() -> void:
	update_card()


func _on_save_button_pressed() -> void:
	await get_tree().create_timer(1).timeout
	%Screenshotter.TAKE_SCREENSHOT(%NameField.text)


func _on_art_button_pressed() -> void:
	%ArtFileDialog.popup_centered_clamped()


func _on_art_file_dialog_file_selected(path: String) -> void:
	art_path = path
	art_file = ImageTexture.create_from_image(Image.load_from_file(path))


func _on_timer_timeout() -> void:
	update_text()
	update_card()


func _on_import_button_pressed() -> void:
	%ImportFileDialog.popup_centered_clamped()


func _on_export_button_pressed() -> void:
	%ExportFileDialog.popup_centered_clamped()


func _on_import_file_dialog_file_selected(path: String) -> void:
	saved_card = Global.parse_json(path)
	load_card()


func _on_export_file_dialog_dir_selected(dir: String) -> void:
	save_card()
	print(dir)
	var file_name : String = %NameField.text.replace(" ","-").replace(",","").replace(".","").replace("!","").replace(":","").replace("?","")
	var path : String = dir + "/" + "tcrpg-card_" + file_name + ".json"
	Global.save_json(saved_card, path)
