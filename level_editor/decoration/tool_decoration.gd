extends Tool_LevelEditor

@onready var depth_scene: Node2D = $Scene
var decoration : Array[DecoInstance]

func _save_data() -> void:
	pass


func _load_data() -> void:
	var resources := {}
	for i in level.deco_textures.size():
		var obj = ImageTexture.create_from_image(Image.load_from_file(ProjectManager.convert_path(level.deco_textures[i])))
		if obj:
			resources[i] = obj

	for data in level.decoration:
		var template : DecoTemplate

		match data["decoration_type"]:
			LevelFile.DECO_IMAGE:
				var texture := resources[data["filepath_index"]] as Texture2D
				template = DecoImage.from_texture(texture)
			LevelFile.DECO_ATLAS:
				var atlas := resources[data["filepath_index"]] as Texture2D
				template = DecoAtlas.create(atlas, data["region"])
		
		var instance := DecoInstance.new()
		instance.template = template
		instance.node = template._place()
		instance.node.transform = data["transform"]
		instance.node.modulate = data.get("color", Color.WHITE)
		instance.depth = data.get("depth", 0.0)
		####################################
		depth_scene.add_child(instance.node)
		decoration.append(instance)
