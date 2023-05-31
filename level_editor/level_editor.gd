extends Node

@export var is_standalone := true

var current_level : LevelFile
var current_path : String

var tools : Array[Tool_LevelEditor]
var current_tool := -1


func _enter_tree() -> void:
	if is_standalone:
		current_level = LevelFile.new()
		current_level.world_settings = ProjectManager.project
		current_level.size = ProjectManager.project.minimum_screen_size
#		CameraManager.activate()
#		CameraManager.position = $Camera.position


func _ready() -> void:
	init_tools()
	select_tool(0)


func init_tools() -> void:
	for t in tools:
		t.level = current_level
		t._initialize()
		t.set_active(false)


func select_tool(index: int) -> void:
	if index == current_tool:
		return
	
	if index >= 0:
		tools[index].enable_tool()
	if current_tool >= 0:
		tools[current_tool].disable_tool()
	
	current_tool = index


func save_current_level() -> void:
	if current_path != "":
		save_to_disk(current_path)
#	else:
#		save_dialogue.request_file()
#		var filepath = await save_dialogue.file_submitted
#		if filepath != "" and filepath != null:
#			save_to_disk(filepath)


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
		t.save_data()
	
	current_level.save_to_file(ProjectManager.convert_path(path))
