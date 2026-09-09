extends Node2D
class_name Screenshotter

@export_category("Screenshot Settings")
## If true, the screenshot will be upscaled.
## If false, the screenshot will be at its native resolution.
@export var upscale : bool = true
## Upscale by what factor?
@export var scaleFactor : int = 5

@onready var resizedWidth : int = get_viewport_rect().size.x * scaleFactor
@onready var resizedHeight : int = get_viewport_rect().size.y * scaleFactor

func TAKE_SCREENSHOT(file_name : String, screenshot_path : String):
	var date = Time.get_datetime_string_from_system().replace(".","_").replace(":","_")
	file_name = file_name.replace(" ","-").replace(",","").replace(".","").replace("!","").replace(":","").replace("?","")
	screenshot_path = screenshot_path + "/" + "tcrpg-card_" + file_name + "_" + date + ".png"
	var image = get_viewport().get_texture().get_image()

	if upscale:
		var resizedImage = Image.new()

		resizedImage.create(resizedWidth,resizedHeight,false,Image.FORMAT_BPTC_RGBA)
		image.resize(resizedWidth,resizedHeight,Image.INTERPOLATE_NEAREST)
		resizedImage.blit_rect(image,Rect2(Vector2.ZERO,image.get_size()),Vector2.ZERO)

	image.save_png(screenshot_path)
