class_name DecoAtlas
extends DecoTemplate

var atlas : Texture2D
var region : Rect2


static func create(p_texture: Texture2D, p_region: Rect2) -> DecoAtlas:
	var deco := DecoAtlas.new()
	deco.atlas = p_texture
	deco.region = p_region
	return deco


func _get_type_id() -> int:
	return LevelFile.DECO_ATLAS


func _place() -> Node2D:
	var node := Sprite2D.new()
	node.texture = atlas
	node.region_enabled = true
	node.region = region
	return node


func _get_preview() -> Texture2D:
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = region
	return tex


func _get_rect() -> Rect2:
	return Rect2(-region.size * 0.5, region.size)


func _get_data() -> Dictionary:
	return {"region": region}
