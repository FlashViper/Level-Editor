extends Control

signal selected_image(texture: Texture2D, filepath: String)

@onready var preview_window: Control = %PreviewWindow
@onready var preview: TextureRect = %Preview
@onready var filepath: LineEdit = %Filepath
@onready var load_dialog: Popup = $LoadDialog

var current_filepath : String
var current_texture : Texture2D

func _ready() -> void:
	%Open.pressed.connect(on_open_pressed)
	%Add.pressed.connect(on_add_pressed)
	filepath.text_submitted.connect(on_filepath_sumbitted)
	preview_window.gui_input.connect(on_preview_input)


func on_open_pressed() -> void:
	load_dialog.request_file()
	var filepath : String = await load_dialog.file_submitted
	if filepath != "":
		on_filepath_sumbitted(filepath)


func on_add_pressed() -> void:
	if current_texture:
		selected_image.emit(current_texture, current_filepath)
	%Add.release_focus()


func on_preview_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT > 0:
			preview.position += event.relative
	elif event is InputEventMouseButton:
		const SCALE_FACTOR := 35
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				scale_preview(SCALE_FACTOR)
			MOUSE_BUTTON_WHEEL_DOWN:
				scale_preview(-SCALE_FACTOR)


func scale_preview(amount: float) -> void:
	preview.size += preview.size.normalized() * amount
	preview.size = preview.size.clamp(Vector2.ONE * 64, Vector2.INF)
	preview.position = (preview_window.size - preview.size) * 0.5


func on_filepath_sumbitted(path: String) -> void:
	if path.get_extension() == "":
		path += ".png"
		
	current_filepath = path
	filepath.text = path
	filepath.release_focus()
	%Add.grab_focus()
	
	reload_image_file()


func reload_image_file() -> void:
	var path := ProjectManager.convert_path(current_filepath)
	if !FileAccess.file_exists(path):
		printerr("Image does not exist at path '%s'" % path)
		return
	
	var img := Image.load_from_file(path)
	if !img:
		printerr("File at '%s' was not a valid image" % path)
		return
	
	current_texture= ImageTexture.create_from_image(img)
	preview.texture = current_texture
	focus_preview()

func focus_preview() -> void:
	preview.position = Vector2.ZERO 
	preview.size = preview_window.size
	preview.pivot_offset = preview_window.size * 0.5


func reset() -> void:
	load_dialog.reset()
	current_filepath = ""
	current_texture = null
	preview.texture = null
	filepath.text = ""
