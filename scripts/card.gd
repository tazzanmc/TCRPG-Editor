extends Control
class_name Card


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
	var i : int = 0
	for guild in new_guilds:
		if i == 0:
			if guild == true:
				%ArdorSymbol.visible = true
			else:
				%ArdorSymbol.visible = false
		if i == 1:
			if guild == true:
				%SparkSymbol.visible = true
			else:
				%SparkSymbol.visible = false
		if i == 2:
			if guild == true:
				%SteamSymbol.visible = true
			else:
				%SteamSymbol.visible = false
		if i == 3:
			if guild == true:
				%RootSymbol.visible = true
			else:
				%RootSymbol.visible = false
		if i == 4:
			if guild == true:
				%GraveSymbol.visible = true
			else:
				%GraveSymbol.visible = false
		i += 1


func change_font_size(font_size: int):
	%AbilitiesLabel["theme_override_font_sizes/normal_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/bold_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/bold_italics_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/italics_font_size"] = font_size
	%AbilitiesLabel["theme_override_font_sizes/mono_font_size"] = font_size
