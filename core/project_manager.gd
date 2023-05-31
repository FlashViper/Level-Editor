extends Node

const PROJECT_ALIAS := "proj:/"

var project : WorldSettings
var project_path : String


func convert_path(path_in: String) -> String:
	var directory := project_path.get_base_dir()
	return path_in.replace(PROJECT_ALIAS, directory)


func save_to_file() -> void:
	ResourceSaver.save(project, convert_path(project_path))


func load_from_file(path: String) -> void:
	project_path = path
	project = ResourceLoader.load(project_path)
