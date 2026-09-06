extends Node

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


func format_rich_text(old_text: String) -> String:
	var new_text: String
	
	## Replace guild icons
	new_text = old_text.replace("{a}","[img height=1.2em]res://assets/textures/ardor_text.png[/img]")
	new_text = new_text.replace("{g}","[img height=1.2em]res://assets/textures/grave_text.png[/img]")
	new_text = new_text.replace("{r}","[img height=1.2em]res://assets/textures/root_text.png[/img]")
	new_text = new_text.replace("{s}","[img height=1.2em]res://assets/textures/spark_text.png[/img]")
	new_text = new_text.replace("{t}","[img height=1.2em]res://assets/textures/steam_text.png[/img]")
	
	## Repeat for caps
	new_text = new_text.replace("{A}","[img height=1.2em]res://assets/textures/ardor_text.png[/img]")
	new_text = new_text.replace("{G}","[img height=1.2em]res://assets/textures/grave_text.png[/img]")
	new_text = new_text.replace("{R}","[img height=1.2em]res://assets/textures/root_text.png[/img]")
	new_text = new_text.replace("{S}","[img height=1.2em]res://assets/textures/spark_text.png[/img]")
	new_text = new_text.replace("{T}","[img height=1.2em]res://assets/textures/steam_text.png[/img]")
	
	## Generic costs
	new_text = new_text.replace("{0}","[img height=1.2em]res://assets/textures/generic_0.png[/img]")
	new_text = new_text.replace("{1}","[img height=1.2em]res://assets/textures/generic_1.png[/img]")
	new_text = new_text.replace("{2}","[img height=1.2em]res://assets/textures/generic_2.png[/img]")
	new_text = new_text.replace("{3}","[img height=1.2em]res://assets/textures/generic_3.png[/img]")
	new_text = new_text.replace("{4}","[img height=1.2em]res://assets/textures/generic_4.png[/img]")
	new_text = new_text.replace("{5}","[img height=1.2em]res://assets/textures/generic_5.png[/img]")
	new_text = new_text.replace("{6}","[img height=1.2em]res://assets/textures/generic_6.png[/img]")
	new_text = new_text.replace("{7}","[img height=1.2em]res://assets/textures/generic_7.png[/img]")
	new_text = new_text.replace("{8}","[img height=1.2em]res://assets/textures/generic_8.png[/img]")
	new_text = new_text.replace("{9}","[img height=1.2em]res://assets/textures/generic_9.png[/img]")
	
	return new_text
