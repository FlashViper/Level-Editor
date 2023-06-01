class_name DecoImage
extends DecoTemplate

var texture : Texture2D

static func from_texture(p_texture: Texture2D) -> DecoImage:
	var deco := DecoImage.new()
	deco.texture = p_texture
	return deco


func _get_type_id() -> int:
	return LevelFile.DECO_IMAGE


func _place() -> Node2D:
	var node := Sprite2D.new()
	node.texture = texture
	return node


func _get_preview() -> Texture2D:
	return texture
