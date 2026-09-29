extends Control

const main_scene = preload("res://scenes/main.tscn")

var art_path : String = "res://assets/textures/art_placeholder.png"
var loaded_cards : int = 0

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


func create_card(card_path: String, card: Dictionary = saved_card, card_it: int = 0, cards_per_row: int = 0, x_offset: float = 0.0, y_offset: float = 0.0) -> void:
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


func _on_card_viewer_file_dialog_files_selected(paths: PackedStringArray) -> void:
	var cards_per_row : int = 6
	
	if paths.is_empty():
		go_to_main_menu()
	else:
		for i in paths.size():
			saved_card = Global.parse_json(paths[i])
			create_card(paths[i], saved_card, i, cards_per_row)
			loaded_cards += 1
			%LoadedCardsLabel.text = ("Loaded " + str(loaded_cards) + " cards")


func _on_card_viewer_file_dialog_canceled() -> void:
	go_to_main_menu()


func go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_scene)
