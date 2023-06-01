extends Node

@export var default_tool := -1
@export var is_standalone := true
@export var toolbar_scene : PackedScene

@onready var canvas: CanvasLayer = $Canvas
@onready var save_dialog := $SaveDialog
@onready var open_dialog := $OpenDialog

var editor : LevelEditorData
var current_level : LevelFile
var current_path : String

var tools : Array[Tool_LevelEditor]
var current_tool := -1

var toolbar : Control


func _enter_tree() -> void:
	if is_standalone:
		current_level = LevelFile.new()
		current_level.world_settings = ProjectManager.project
		current_level.size = ProjectManager.project.minimum_screen_size
		CameraManager.activate()
		CameraManager.position = $CameraTarget.position


func _ready() -> void:
	editor = LevelEditorData.new()
	editor.canvas = canvas
	
	toolbar = toolbar_scene.instantiate()
	toolbar.save_pressed.connect(save_current_level)
	canvas.add_child(toolbar)
	
	init_tools()
	select_tool(0 if default_tool < 0 else default_tool)


func init_tools() -> void:
	tools.clear()
	
	for c in $Tools.get_children():
		if c is Tool_LevelEditor:
			tools.append(c)
	
	for i in tools.size():
		var t := tools[i]
		t.editor = editor
		t.level = current_level
		t._initialize()
		t.disable_tool()
		toolbar.add_tool(t._get_icon(), select_tool.bind(i))


func select_tool(index: int) -> void:
	if index == current_tool or tools.size() < 1:
		return
	
	if index >= 0:
		tools[index].enable_tool()
	if current_tool >= 0:
		tools[current_tool].disable_tool()
	
	current_tool = index


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("save", true):
		save_current_level()
	elif event.is_action("open", true):
		open_dialog.request_file()
		var filepath := await open_dialog.file_submitted as String
		if filepath != "":
			load_from_disk(filepath)


func save_current_level() -> void:
	if current_path != "":
		save_to_disk(current_path)
	else:
		save_dialog.request_file()
		var filepath = await save_dialog.file_submitted
		if filepath != "" and filepath != null:
			save_to_disk(filepath)


func load_from_disk(path_raw: String) -> void:
	var path := ProjectManager.convert_path(path_raw)
	
	if !FileAccess.file_exists(path):
		printerr("Nonexistant level at path %s" % path)
		return
	
	current_path = path
	current_level = LevelFile.load_from_file(path)
	
	for t in tools:
		t.level = current_level
		t._load_data()

	
func save_to_disk(path: String) -> void:
	for t in tools:
		t._save_data()
	
	current_level.save_to_file(ProjectManager.convert_path(path))
