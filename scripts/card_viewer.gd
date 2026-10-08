extends Control

@export var main_scene : String = "res://scenes/main.tscn"

var art_path : String = "res://assets/textures/art_placeholder.png"
var loaded_cards : int = 0
var loaded_card_paths : PackedStringArray

var loaded_ardor_cards : int = 0
var loaded_spark_cards : int = 0
var loaded_steam_cards : int = 0
var loaded_root_cards : int = 0
var loaded_grave_cards : int = 0
var loaded_multi_cards : int = 0
var loaded_guildless_cards : int = 0

@export var card_scene: PackedScene
@export var interactive_sub_viewport: PackedScene
@export var card_resolution: Vector2 = Vector2(762.0, 1080.0)

@onready var art_file : ImageTexture = ImageTexture.create_from_image(Image.load_from_file(art_path))
@onready var saved_card: Dictionary = Global.parse_json("res://assets/default_card.json")
@onready var card_row_container: HBoxContainer = %CardRowContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CardViewerFileDialog.popup_centered_clamped()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func create_card(card_path: String, card: Dictionary = saved_card, card_it: int = 0, cards_per_row: int = 0, sorted: bool = false, x_offset: float = 0.0, y_offset: float = 0.0) -> void:
	# Set the art file path
	if card.has("Art"):
		var json_art_path : String = card["Art"]
		art_path = json_art_path
	else:
		art_path = Global.default_art
	
	art_file = ImageTexture.create_from_image(Image.load_from_file(art_path))
	
	# Create and format the card viewport containers
	var viewport_container: SubViewportContainer = interactive_sub_viewport.instantiate()
	viewport_container.custom_minimum_size = card_resolution
	viewport_container.custom_maximum_size = card_resolution
	viewport_container.offset_transform_enabled = true
	viewport_container.offset_transform_position = Vector2(x_offset, y_offset)
	viewport_container.card_json = card_path
	
	# Create and format the card viewports
	var viewport: SubViewport = SubViewport.new()
	viewport.size = card_resolution
	viewport.transparent_bg = true
	
	# Instance a fresh card
	var card_inst : Card = card_scene.instantiate()
	
	if sorted:
		if Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [true, false, false, false, false]:
			card_row_container = %ArdorRow
		elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, true, false, false, false]:
			card_row_container = %SparkRow
		elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, true, false, false]:
			card_row_container = %SteamRow
		elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, true, false]:
			card_row_container = %RootRow
		elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, false, true]:
			card_row_container = %GraveRow
		elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, false, false]:
			card_row_container = %GuildlessRow
		else:
			card_row_container = %MultiRow
	else:
		# If there's a limit to cards per row, create a new row if the previous one fills up
		if cards_per_row != 0:
			if (card_it % cards_per_row) == 0:
				card_row_container = HBoxContainer.new()
				%CardContainer.add_child(card_row_container)
	
	# Setup hierarchy for all the containers
	card_row_container.add_child(viewport_container)
	viewport_container.add_child(viewport)
	viewport.add_child(card_inst)
	
	# Format the card instance
	card_inst.change_name(Global.set_or_default(card, "Name", ""))
	card_inst.change_traits(Global.set_or_default(card, "Traits", ""))
	card_inst.change_type(Global.set_or_default(card, "Type", "Creature"))
	card_inst.change_power(str(int(Global.set_or_default(card, "Power", 0))))
	card_inst.change_health(str(int(Global.set_or_default(card, "Health", 0))))
	card_inst.change_abilities(Global.set_or_default(card, "Abilities", ""))
	card_inst.change_art(art_file, Vector2(Global.set_or_default(card, "ArtXOffset", 0),Global.set_or_default(card, "ArtYOffset", 0)), Global.set_or_default(card, "ArtScale", 1.0))
	card_inst.change_font_size(Global.set_or_default(card, "FontSize", 32.0))
	card_inst.change_name_width(Global.set_or_default(card, "NameWidth", 10.0))
	if Global.set_or_default(card, "X", false):
		card_inst.change_tribute("X")
	else:
		card_inst.change_tribute(str(int(Global.set_or_default(card, "Tribute", 1))))
	card_inst.change_guids(Global.set_or_default(card, "Guilds", [true, true, true, true, true]))
	
	if Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [true, false, false, false, false]:
		loaded_ardor_cards += 1
	elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, true, false, false, false]:
		loaded_spark_cards += 1
	elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, true, false, false]:
		loaded_steam_cards += 1
	elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, true, false]:
		loaded_root_cards += 1
	elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, false, true]:
		loaded_grave_cards += 1
	elif Global.set_or_default(card, "Guilds", [true, true, true, true, true]) == [false, false, false, false, false]:
		loaded_guildless_cards += 1
	else:
		loaded_multi_cards += 1


func clear_cards() -> void:
	loaded_cards = 0
	loaded_ardor_cards = 0
	loaded_spark_cards = 0
	loaded_steam_cards = 0
	loaded_root_cards = 0
	loaded_grave_cards = 0
	loaded_multi_cards = 0
	loaded_guildless_cards = 0
	
	var container_children : Array = %CardContainer.get_children()
	for i in range(container_children.size()):
		var internal_children : Array = container_children[i].get_children()
		for ii in range(internal_children.size()):
			internal_children[ii].queue_free()


func load_cards(paths: PackedStringArray, cards_per_row: int = 6) -> void:
	clear_cards()
	for i in paths.size():
		saved_card = Global.parse_json(paths[i])
		create_card(paths[i], saved_card, i, cards_per_row, true)
		loaded_cards += 1


func _on_card_viewer_file_dialog_files_selected(paths: PackedStringArray) -> void:
	var cards_per_row : int = 6
	loaded_card_paths = paths
	
	if paths.is_empty():
		go_to_main_menu()
	else:
		load_cards(paths, cards_per_row)


func _on_card_viewer_file_dialog_canceled() -> void:
	go_to_main_menu()


func go_to_main_menu() -> void:
	get_tree().change_scene_to_file(main_scene)


func _on_new_button_pressed() -> void:
	clear_cards()
	%CardViewerFileDialog.popup_centered_clamped()


func _on_reload_button_pressed() -> void:
	clear_cards()
	load_cards(loaded_card_paths)


func _on_timer_timeout() -> void:
	%LoadedCardsLabel.text = (
		"Loaded " + str(loaded_cards) + " cards" + "\n"
		+ "\n"
		+ "Loaded " + str(loaded_ardor_cards) + " Ardor cards" + "\n"
		+ "Loaded " + str(loaded_spark_cards) + " Spark cards" + "\n"
		+ "Loaded " + str(loaded_steam_cards) + " Steam cards" + "\n"
		+ "Loaded " + str(loaded_root_cards) + " Root cards" + "\n"
		+ "Loaded " + str(loaded_grave_cards) + " Grave cards" + "\n"
		+ "Loaded " + str(loaded_multi_cards) + " Multi-guild cards" + "\n"
		+ "Loaded " + str(loaded_guildless_cards) + " Guildless cards" + "\n"
		)
