extends Node

@export var is_standalone := true

var current_level : LevelFile
var tools : Array[Tool_LevelEditor]


func _enter_tree() -> void:
	if is_standalone:
		current_level = LevelFile.new()
#		current_level.world_settings = ProjectManager.current_project
#		current_level.size = ProjectManager.current_project.minimum_screen_size
#
#		DisplayServer.window_set_size(Vector2i(1920, 1080))
#
#		CameraManager.activate()
#		CameraManager.position = $Camera.position


func _ready() -> void:
	init_tools()


func init_tools() -> void:
	for t in tools:
		t.level = current_level
		t._initialize()
		t.set_active(false)
