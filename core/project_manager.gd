extends Node

const PROJECT_ALIAS := "proj:/"
const DEBUG_PATH := "
C:/Users/ellio/Godot/Projects/AnimatedGame/metroidvania/assets/settings_default.tres"

var project : WorldSettings
var project_path : String


func _enter_tree() -> void:
	load_from_file(DEBUG_PATH)


func convert_path(path_in: String) -> String:
	var directory := project_path.get_base_dir()
	return path_in.replace(PROJECT_ALIAS, directory)


func save_to_file() -> void:
	ResourceSaver.save(project, convert_path(project_path))


func load_from_file(path: String) -> void:
	project_path = path
	project = ResourceLoader.load(project_path)
