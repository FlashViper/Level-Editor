extends PanelContainer

signal palette_changed


@onready var image_selector: Control = $ImageSelector
var palette := DecoPalette.new()


func mode_set_single_image() -> void:
	var img := await get_image()
	
	var template := DecoImage.from_texture(img["texture"])
	template.path = img["path"]
	palette.templates.append(template)
	
	palette_changed.emit()


func get_image() -> Dictionary:
	image_selector.reset()
	for c in get_children():
		c.visible = (c == image_selector)
	
	var data := await image_selector.selected_image as Array
	return {
		"texture": data[0],
		"path": data[1],
	}
