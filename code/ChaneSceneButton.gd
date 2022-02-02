tool
extends Button
onready var load_screen = load("res://scenes/Screens/loading.tscn")

export(String, FILE) var next_scene_path: = ""

func _on_button_up():
	#get_tree().root.add_child(load_screen)
	get_tree().change_scene('res://scenes/Screens/loading.tscn')


func _get_configuration_warning() -> String:
	return "Next_scene_path must be set for the button to work" if next_scene_path == "" else ""
