extends Control
class_name Card

@export var card_json_path : String = Global.default_card

func update_card() -> void:
	var new_card = Global.parse_json(card_json_path)
	var art_path : String
	
	# Set the art file path
	if new_card.has("Art"):
		var json_art_path : String = new_card["Art"]
		art_path = json_art_path
	else:
		art_path = Global.default_art
	
	var art_file = ImageTexture.create_from_image(Image.load_from_file(art_path))
	
	# Format card
	change_name(Global.set_or_default(new_card, "Name", ""))
	change_traits(Global.set_or_default(new_card, "Traits", ""))
	change_type(Global.set_or_default(new_card, "Type", "Creature"))
	change_power(str(int(Global.set_or_default(new_card, "Power", 0))))
	change_health(str(int(Global.set_or_default(new_card, "Health", 0))))
	change_abilities(Global.set_or_default(new_card, "Abilities", ""))
	change_art(art_file, Vector2(Global.set_or_default(new_card, "ArtXOffset", 0),Global.set_or_default(new_card, "ArtYOffset", 0)), Global.set_or_default(new_card, "ArtScale", 1.0))
	change_font_size(Global.set_or_default(new_card, "FontSize", 32.0))
	change_name_width(Global.set_or_default(new_card, "NameWidth", 10.0))
	if Global.set_or_default(new_card, "X", false):
		change_tribute("X")
	else:
		change_tribute(str(int(Global.set_or_default(new_card, "Tribute", 1))))
	change_guids(Global.set_or_default(new_card, "Guilds", [true, true, true, true, true]))


func change_name(new_str: String) -> void:
	%NameLabel.text = new_str


func change_traits(new_str: String) -> void:
	%TraitsLabel.text = new_str


func change_type(new_str: String) -> void:
	%TypeLabel.text = new_str
	if new_str == "Creature" or new_str == "Team Captain":
		%CardPowerHealth.visible = true
		%PowerLabel.visible = true
		%HealthLabel.visible = true
		%TributeLabel.visible = true
	elif new_str == "Curse" or new_str == "Tribute":
		%CardPowerHealth.visible = false
		%PowerLabel.visible = false
		%HealthLabel.visible = false
		%TributeLabel.visible = false
	else:
		%CardPowerHealth.visible = false
		%PowerLabel.visible = false
		%HealthLabel.visible = false
		%TributeLabel.visible = true


func change_abilities(new_str: String) -> void:
	new_str = Global.format_rich_text(new_str)
	%AbilitiesLabel.text = new_str


func change_power(new_str: String) -> void:
	%PowerLabel.text = new_str


func change_health(new_str: String) -> void:
	%HealthLabel.text = new_str


func change_tribute(new_str: String) -> void:
	%TributeLabel.text = new_str


func change_art(new_tex: Texture2D, new_offset: Vector2 = Vector2(0.0, 0.0), new_scale: float = 1.0) -> void:
	%CardArt.texture = new_tex
	%CardArt.position = new_offset
	%CardArt.scale = Vector2(new_scale, new_scale)


func change_guids(new_guilds: Array) -> void:
	if new_guilds == [false, false, false, false, false]:
		%CardOutline.modulate = Color(1.0, 1.0, 1.0)
	
	for i in range(new_guilds.size()):
		if new_guilds[0] == true:
			%ArdorSymbol.visible = true
			%CardOutline.modulate = Color(0.61, 0.898, 0.61)
		else:
			%ArdorSymbol.visible = false
			
		if new_guilds[1] == true:
			%SparkSymbol.visible = true
			%CardOutline.modulate = Color(1.481, 0.898, 0.316)
		else:
			%SparkSymbol.visible = false
			
		if new_guilds[2] == true:
			%SteamSymbol.visible = true
			%CardOutline.modulate = Color(0.607, 0.898, 1.19)
		else:
			%SteamSymbol.visible = false
			
		if new_guilds[3] == true:
			%RootSymbol.visible = true
			%CardOutline.modulate = Color(0.898, 0.606, 0.313)
		else:
			%RootSymbol.visible = false
			
		if new_guilds[4] == true:
			%GraveSymbol.visible = true
			%CardOutline.modulate = Color(0.898, 0.61, 0.898)
		else:
			%GraveSymbol.visible = false


func change_font_size(font_size: int):
	%AbilitiesLabel["theme_override_font_sizes/normal_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/bold_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/bold_italics_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/italics_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/mono_font_size"] = font_size


func change_name_width(name_width: float):
	$%NameLabel.scale.x = name_width / 10
