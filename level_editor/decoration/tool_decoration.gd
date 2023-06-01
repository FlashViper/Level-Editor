extends Tool_LevelEditor

@onready var depth_scene: Node2D = $Scene
@onready var deco_widget: Node2D = $TransformWidget

var decoration : Array[DecoInstance]
var selected : Array[int]

func _initialize() -> void:
	depth_scene.initialize(ProjectManager.project.screen_size_px)
	deco_widget.translated.connect(on_decoration_translated)
	deco_widget.rotated.connect(on_decoration_rotated)
	deco_widget.scaled.connect(on_decoration_scaled)
	deco_widget.deselected.connect(on_deselect)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !event.is_pressed():
				if selected.size() > 0:
					return
				
				var mouse_pos := depth_scene.get_local_mouse_position()
				for i in decoration.size():
					if decoration[i].intersects_point(mouse_pos):
						selected = [i]
						break
				
				if selected.size() > 0:
					deco_widget.edit(decoration[selected[0]])


func on_decoration_translated(by: Vector2) -> void:
	if selected.size() < 1:
		return
	
	for s in selected:
		depth_scene.root_positions[s] += by


func on_decoration_rotated(by: float) -> void:
	if selected.size() < 1:
		return
	
	for s in selected:
		decoration[s].node.rotate(by)


func on_decoration_scaled(by: float) -> void:
	if selected.size() < 1:
		return
	
	for s in selected:
		decoration[s].node.scale += Vector2.ONE * by
		decoration[s].node.scale = decoration[s].node.scale.abs()


func on_decoration_depth_changed(new: float) -> void:
	if selected.size() < 1:
		return
	
	printerr("changing the depth of decoration is not implimented yet :(")


func on_deselect() -> void:
	selected = []
	deco_widget.edit(null)


func _save_data() -> void:
	pass


func _load_data() -> void:
	depth_scene.project = level.world_settings
	depth_scene.initialize(level.world_settings.screen_size_px)
	
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
		
		depth_scene.add_object(instance.node, instance.depth, false)
		decoration.append(instance)


