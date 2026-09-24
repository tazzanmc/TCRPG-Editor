extends Button

@export var file_path : String = "res://scenes/card_viewer.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(file_path)
